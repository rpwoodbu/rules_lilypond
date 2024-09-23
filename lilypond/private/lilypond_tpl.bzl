load("//lilypond/private:provider.bzl", "LilyPondProvider")
load("//:extensions.bzl", "LILYPOND_VERSION")

lilypond_tpl_common_attrs = {
    "music_map": attr.string_dict(
        doc = "Map of LilyPond variables containing music for the score to their instrument names.",
    ),
    "music_map_short": attr.string_dict(
        doc = "Map of LilyPond variables containing music for the score to their short instrument names.",
    ),
    "instrument": attr.string(
        doc = "Name of instrument.",
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
}

def lilypond_tpl_impl(ctx):
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

    if hasattr(ctx.attr, "music_var"):
        music_map = { ctx.attr.music_var: ctx.attr.instrument }
    else:
        music_map = ctx.attr.music_map
    staves = []
    for music, instrument in music_map.items():
        if music.startswith("\\"):
            fail("Do not prefix music variable name with a backslash")

        if ctx.attr.staff_with:
            staves.append('\\new Staff \\with {{ {} }} {{'.format(ctx.attr.staff_with))
        else:
            staves.append('\\new Staff {')

        if ctx.attr._is_part:
            staves.append('  \\set Score.skipBars = ##t')
        else:
            staves.append('  \\set Staff.instrumentName = "{}"'.format(instrument))
            short_name = ctx.attr.music_map_short.get(music, None)
            if short_name != None:
                staves.append('  \\set Staff.shortInstrumentName = "{}"'.format(short_name))

        staves.extend(ctx.attr.staff)

        staves.extend([
            '  \\{}'.format(music),
            '}',
        ])
    subs.add("{STAVES}", "\n".join(staves))

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
