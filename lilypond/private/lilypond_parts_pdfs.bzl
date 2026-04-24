load("//lilypond/private:lilypond_part.bzl", "lilypond_part")
load("//lilypond/private:lilypond_pdf.bzl", "lilypond_pdf")

def _lilypond_parts_pdfs_impl(name, visibility, music_map, warning_as_error, **kwargs):
    all_parts = []
    for music_var, instrument in music_map.items():
        part_name = "{}_{}_ly".format(name, music_var)
        lilypond_part(
            name = part_name,
            music_var = music_var,
            instrument = instrument,
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
    inherit_attrs = lilypond_part,
    attrs = {
        "music_map": attr.string_dict(
            doc = "Map of music variable names to instrument names.",
            configurable = False,
        ),
        "warning_as_error": attr.bool(default = True),
        "music_var": None,
        "instrument": None,
    },
)
