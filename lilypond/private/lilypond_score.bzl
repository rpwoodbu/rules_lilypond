load("//lilypond/private:lilypond_tpl.bzl", "lilypond_tpl_impl", "lilypond_tpl_common_attrs")

lilypond_score = rule(
    implementation = lilypond_tpl_impl,
    attrs = lilypond_tpl_common_attrs | {
        "music_map": attr.string_dict(
            doc = "Map of LilyPond variables containing music for the score to their instrument names.",
        ),
        "music_map_short": attr.string_dict(
            doc = "Map of LilyPond variables containing music for the score to their short instrument names.",
        ),
        "template": attr.label(
            allow_single_file = [".ly.tpl"],
            default = "//lilypond:score.ly.tpl",
            doc = "Template for generating part."
        )
    },
)
