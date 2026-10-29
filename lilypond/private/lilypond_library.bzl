load("//lilypond/private:provider.bzl", "LilyPondProvider")

def _lilypond_library_impl(ctx):
    quotes = {}
    quote_transpositions = {}
    transposition = ctx.attr.transposition
    for dep in ctx.attr.deps:
        quotes.update(dep[LilyPondProvider].quotes)
        quote_transpositions.update(dep[LilyPondProvider].quote_transpositions)
        if dep[LilyPondProvider].music_var and dep[LilyPondProvider].transposition:
            quote_transpositions[dep[LilyPondProvider].music_var] = dep[LilyPondProvider].transposition
        if not transposition and dep[LilyPondProvider].transposition:
            transposition = dep[LilyPondProvider].transposition
    quotes.update(ctx.attr.quotes)

    if ctx.attr.music_var and transposition:
        quote_transpositions[ctx.attr.music_var] = transposition
    if transposition:
        for music in ctx.attr.quotes:
            if music not in quote_transpositions:
                quote_transpositions[music] = transposition

    return [
        DefaultInfo(
            files = depset(ctx.files.srcs),
        ),
        LilyPondProvider(
            music_var = ctx.attr.music_var,
            movement = ctx.attr.movement,
            instrument = ctx.attr.instrument,
            short_instrument = ctx.attr.short_instrument,
            transposition = transposition,
            quotes = quotes,
            quote_transpositions = quote_transpositions,
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
        "transposition": attr.string(
            doc = "Pitch for LilyPond's \\transposition command. Prefer to " +
                  "use this instead of setting \\transposition directly, " +
                  "to ensure that cues are displayed correctly.",
        ),
        "quotes": attr.string_dict(
            doc = "Map of music variables to their referenced names when " +
                  "using \\cueDuring.",
        ),
        "deps": attr.label_list(
            providers = [LilyPondProvider],
        ),
    },
)
