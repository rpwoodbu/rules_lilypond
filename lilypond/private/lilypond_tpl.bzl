load("//lilypond/private:provider.bzl", "LilyPondProvider")
load("//:extensions.bzl", "LILYPOND_VERSION")

lilypond_tpl_common_attrs = {
    "instrument": attr.string(
        doc = "Name of instrument",
    ),
    "composer": attr.string(
        doc = "Name of composer",
    ),
    "title": attr.string(
        doc = "Title of piece",
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

    subs = ctx.actions.template_dict()
    subs.add("{VERSION}", LILYPOND_VERSION)
    subs.add("{INCLUDES}", "\n".join(['\\include "{}"'.format(i) for i in includes]))
    subs.add("{HEADER}", "\n".join(header))

    if hasattr(ctx.attr, "music_var"):
        if ctx.attr.music_var.startswith("\\"):
            fail("Do not prefix music variable name with a backslash")
        subs.add("{MUSIC}", ctx.attr.music_var)
    else:
        staves = []
        for music, instrument in ctx.attr.music_map.items():
            if music.startswith("\\"):
                fail("Do not prefix music variable name with a backslash")
            staves.extend([
                '\\new Staff {',
                '  \\set Staff.instrumentName = "{}"'.format(instrument),
            ])
            short_name = ctx.attr.music_map_short.get(music, None)
            if short_name != None:
                staves.append('  \\set Staff.shortInstrumentName = "{}"'.format(short_name))
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
