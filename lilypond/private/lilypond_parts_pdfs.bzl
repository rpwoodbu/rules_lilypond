load("//lilypond/private:lilypond_book.bzl", "lilypond_book")
load("//lilypond/private:lilypond_pdf.bzl", "lilypond_pdf")

def _lilypond_parts_pdfs_impl(name, visibility, dep_map, music_inst_map, warning_as_error, **kwargs):
    all_parts = []
    for dep, music_var in dep_map.items():
        part_name = "{}_{}_book".format(name, music_var)
        lilypond_book(
            name = part_name,
            music_var = music_var,
            instrument = music_inst_map.get(music_var, ""),
            deps = [dep],
            visibility = visibility,
            **kwargs,
        )
        all_parts.append(part_name)

    lilypond_pdf(
        name = name,
        deps = all_parts,
        warning_as_error = warning_as_error,
        visibility = visibility,
    )

lilypond_parts_pdfs = macro(
    doc = """Creates parts and PDFs with the same attributes.

    Based on the contents of `music_map`, creates a set of `lilypond_part`
    targets and a `lilypond_pdf` target. The part targets are named like
    `NAME_INSTRUMENT_LY`, and the PDF target's name is simply `NAME`.
    """,
    implementation = _lilypond_parts_pdfs_impl,
    inherit_attrs = lilypond_book,
    attrs = {
        "dep_map": attr.label_keyed_string_dict(
            doc = "Map of labels of `lilypond_library` targets to music variable names.",
            mandatory = True,
            configurable = False,
        ),
        "music_inst_map": attr.string_dict(
            doc = "Map of music variable names to instrument names.",
            configurable = False,
        ),
        "warning_as_error": attr.bool(default = True),
        "deps": None,
        "music_var": None,
        "instrument": None,
    },
)
