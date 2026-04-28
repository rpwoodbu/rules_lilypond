load("//lilypond/private:provider.bzl", "LilyPondProvider")

def _lilypond_library_impl(ctx):
    return [
        DefaultInfo(
            files = depset(ctx.files.srcs),
        ),
        LilyPondProvider(
            music_var = ctx.attr.music_var,
            movement = ctx.attr.movement,
            instrument = ctx.attr.instrument,
            short_instrument = ctx.attr.short_instrument,
            includes = depset(
                ctx.files.srcs,
                transitive = [d[LilyPondProvider].includes for d in ctx.attr.deps],
            ),
        ),
    ]

lilypond_library = rule(
    implementation = _lilypond_library_impl,
    attrs = {
        "srcs": attr.label_list(
            doc = "LilyPond files.",
            allow_empty = True,
            allow_files = [".ly"],
        ),
        "music_var": attr.string(
            doc = "Name of the variable that contains the music. Use if this " +
                  "library contains music that should be rendered.",
        ),
        "movement": attr.string(
            doc = "Name of the movement.",
        ),
        "instrument": attr.string(
            doc = "Name of the instrument. Use with `music_var`.",
        ),
        "short_instrument": attr.string(
            doc = "Short name of the instrument. Use with `instrument`.",
        ),
        "deps": attr.label_list(
            providers = [LilyPondProvider],
        ),
    },
)
