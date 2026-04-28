load("//lilypond/private:provider.bzl", "LilyPondProvider")
load("//:extensions.bzl", "LILYPOND_VERSION")

def lilypond_book_impl(ctx):
    includes_depsets = [d[LilyPondProvider].includes for d in ctx.attr.deps]
    includes = [i.path for ds in includes_depsets for i in ds.to_list()]

    movement_dep_map = {}
    instruments = set()
    for dep in ctx.attr.deps:
        movement_dep_map.setdefault(dep[LilyPondProvider].movement, []).append(dep)
        instrument = dep[LilyPondProvider].instrument
        if instrument:
            instruments.add(instrument)

    header = []
    if len(instruments) == 1:
        # This is a single part. Show the instrument name.
        header.append('instrument = "{}"'.format(instruments.pop()))
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

    movements = ctx.attr.movements if len(ctx.attr.movements) > 0 else [""]
    scores = []
    for movement in movements:
        scores.extend([
            '\\score {',
            '  {',
            '    \\new StaffGroup <<',
        ])

        for dep in movement_dep_map[movement]:
            if ctx.attr.staff_with:
                scores.append('      \\new Staff \\with {{ {} }} {{'.format(ctx.attr.staff_with))
            else:
                scores.append('      \\new Staff {')
            if ctx.attr.skip_bars:
                scores.append('        \\set Score.skipBars = ##t') 
            else:
                scores.append('        \\set Staff.instrumentName = "{}"'.format(dep[LilyPondProvider].instrument))
                short_name = dep[LilyPondProvider].short_instrument
                if short_name != None:
                    scores.append('        \\set Staff.shortInstrumentName = "{}"'.format(short_name))

            scores.extend(ctx.attr.staff)
            scores.extend([
                '        \\{}'.format(dep[LilyPondProvider].music_var),
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
        LilyPondProvider(
            includes = depset(transitive = includes_depsets),
        ),
    ]

lilypond_book = rule(
    doc = """Generates a LilyPond "book" file.""",
    implementation = lilypond_book_impl,
    attrs = {
        "composer": attr.string(
            doc = "Name of composer.",
        ),
        "title": attr.string(
            doc = "Title of piece.",
        ),
        "subtitle": attr.string(
            doc = "Subtitle of piece.",
        ),
        "movements": attr.string_list(
            doc = "List of movement names in the order they should be " +
                  "rendered. Use with the `movement` attribute of " +
                  "`lilypond_library`.",
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
