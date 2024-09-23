load("//lilypond/private:lilypond_tpl.bzl", "lilypond_tpl_impl", "lilypond_tpl_common_attrs")

lilypond_score = rule(
    implementation = lilypond_tpl_impl,
    attrs = lilypond_tpl_common_attrs | {
        "template": attr.label(
            allow_single_file = [".ly.tpl"],
            default = "//lilypond:score.ly.tpl",
            doc = "Template for generating part."
        ),
        "_is_part": attr.bool(default = False),
    },
)
