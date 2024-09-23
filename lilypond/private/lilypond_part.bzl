load("//lilypond/private:lilypond_tpl.bzl", "lilypond_tpl_impl", "lilypond_tpl_common_attrs")

lilypond_part = rule(
    implementation = lilypond_tpl_impl,
    attrs = lilypond_tpl_common_attrs | {
        "music_var": attr.string(
            doc = "LilyPond variable containing music for the part.",
        ),
        "template": attr.label(
            allow_single_file = [".ly.tpl"],
            default = "//lilypond:part.ly.tpl",
            doc = "Template for generating part."
        ),
        "_is_part": attr.bool(default = True),
    },
)
