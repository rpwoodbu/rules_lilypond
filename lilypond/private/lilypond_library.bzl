load("//lilypond/private:provider.bzl", "LilyPondProvider")

def _lilypond_library_impl(ctx):
    return LilyPondProvider(
        includes = depset(
            ctx.files.srcs,
            transitive = [d[LilyPondProvider].includes for d in ctx.attr.deps],
        ),
    )

lilypond_library = rule(
    implementation = _lilypond_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            allow_files = True,
        ),
        "deps": attr.label_list(
            providers = [LilyPondProvider],
        ),
    },
)
