load("//lilypond/private:provider.bzl", "LilyPondProvider")
load("//:extensions.bzl", "LILYPOND_VERSION")

def lilypond_book_impl(ctx):
    includes_depsets = [d[LilyPondProvider].includes for d in ctx.attr.deps]
    includes = [i.path for ds in includes_depsets for i in ds.to_list()]

    header = []
    if ctx.attr.instrument:
        header.append('instrument = "{}"'.format(ctx.attr.instrument))
    if ctx.attr.composer:
        header.append('composer = "{}"'.format(ctx.attr.composer))
    if ctx.attr.title:
        header.append('title = "{}"'.format(ctx.attr.title))
    if ctx.attr.subtitle:
        header.append('subtitle = "{}"'.format(ctx.attr.subtitle))

    subs = ctx.actions.template_dict()
    subs.add("{VERSION}", LILYPOND_VERSION)
    subs.add("{INCLUDES}", "\n".join(['\\include "{}"'.format(i) for i in includes]))
    subs.add("{PAPER}", "\n".join(ctx.attr.paper))
    subs.add("{HEADER}", "\n".join(header))
    subs.add("{QUOTES}", "\n".join(['\\addQuote "{}" {{ \\{} }}'.format(ref, music) for music, ref in ctx.attr.quotes.items()]))

    # Movement map needs to be integrated first to preserve movement order.
    music_map = {}
    movement_map = {}
    if ctx.attr.music_var:
        if len(ctx.attr.music_mvmt_map) > 0:
            fail("Use only one of `music_var` or `music_mvmt_map`")
        music_map[ctx.attr.music_var] = {}
    for music, movement in ctx.attr.music_mvmt_map.items():
        movement_map.setdefault(movement, []).append(music)
    for music, instrument in ctx.attr.music_inst_map.items():
        music_map.setdefault(music, {})["instrument"] = instrument
    for music, short_instrument in ctx.attr.music_short_inst_map.items():
        music_map.setdefault(music, {})["short_instrument"] = short_instrument
    if ctx.attr.instrument:
        if len(ctx.attr.music_inst_map) > 0:
            fail("Use only one of `instrument` or `music_inst_map`")
        for music in music_map:
            music_map[music]["instrument"] = ctx.attr.instrument
    if len(movement_map) == 0:
        # No movements specified. Assume all music is part of the same unnamed
        # movement.
        movement_map[""] = music_map.keys()

    scores = []
    for movement, music_vars in movement_map.items():
        scores.extend([
            '\\score {',
            '  {',
            '    \\new StaffGroup <<',
        ])

        for music in music_vars:
            if ctx.attr.staff_with:
                scores.append('      \\new Staff \\with {{ {} }} {{'.format(ctx.attr.staff_with))
            else:
                scores.append('      \\new Staff {')
            if ctx.attr.skip_bars:
                scores.append('        \\set Score.skipBars = ##t') 
            else:
                scores.append('        \\set Staff.instrumentName = "{}"'.format(music_map[music]["instrument"]))
                short_name = music_map[music].get("short_instrument")
                if short_name != None:
                    scores.append('        \\set Staff.shortInstrumentName = "{}"'.format(short_name))

            scores.extend(ctx.attr.staff)
            scores.extend([
                '        \\{}'.format(music),
                '      }',
            ])

        scores.extend([
            '    >>',
            '  }',
            '  \\header {{ piece = "{}" }}'.format(movement),
            '}',
        ])

    subs.add("{SCORES}", "\n".join(scores))

    out = ctx.actions.declare_file(ctx.label.name + ".ly")
    ctx.actions.expand_template(
        output = out,
        template = ctx.file.template,
        computed_substitutions = subs,
    )

    return [
        DefaultInfo(files = depset([out])),
        LilyPondProvider(includes = depset(transitive = includes_depsets)),
    ]

lilypond_book = rule(
    doc = """Generates a LilyPond "book" file.""",
    implementation = lilypond_book_impl,
    attrs = {
        "music_mvmt_map": attr.string_dict(
            doc = """Map of LilyPond variables containing music to movement names.

Set movement to the empty string to omit. Use `music_var` for single movements.
    """,
        ),
        "music_inst_map": attr.string_dict(
            doc = """Map of LilyPond variables containing music for the score to
their instrument names.

Use `instrument` for single instruments.
    """,
        ),
        "music_short_inst_map": attr.string_dict(
            doc = "Map of LilyPond variables containing music for the score to their short instrument names.",
        ),
        "music_var": attr.string(
            doc = "LilyPond variable containing music for the part. Do not use with `music_mvmt_map`.",
        ),
        "instrument": attr.string(
            doc = "Name of instrument. Do not use with `music_inst_map`.",
        ),
        "composer": attr.string(
            doc = "Name of composer.",
        ),
        "title": attr.string(
            doc = "Title of piece.",
        ),
        "subtitle": attr.string(
            doc = "Subtitle of piece.",
        ),
        "skip_bars": attr.bool(
            doc = "Whether to produce multimeasure rests. Set this to " +
                  "`False` for full scores.",
            default = True,
        ),
        "paper": attr.string_list(
            doc = "List of settings for \\paper.",
        ),
        "quotes": attr.string_dict(
            doc = "Map of LilyPond variables containing music for \\addQuote to their referenced names.",
        ),
        "staff": attr.string_list(
            doc = "List of settings for each \\staff.",
        ),
        "staff_with": attr.string(
            doc = "Items to place in \\with stanza when creating \\new Staff.",
        ),
        "deps": attr.label_list(
            providers = [LilyPondProvider],
        ),
        "template": attr.label(
            allow_single_file = [".ly.tpl"],
            default = "//lilypond:book.ly.tpl",
            doc = "Template for generating LilyPond book."
        ),
    },
)
