load("//lilypond/private:lilypond_library.bzl", "lilypond_library")
load("//lilypond/private:lilypond_part.bzl", "lilypond_part")

def lilypond_parts(name, music_map, prefix = None, **kwargs):
    """music_map: Map of music variable names to instrument names."""

    if prefix == None:
        prefix = "{}.".format(name)

    all_parts = []
    for music_var, instrument in music_map.items():
        part_name = "{}{}".format(prefix, music_var)
        all_parts.append(part_name)
        lilypond_part(
            name = part_name,
            music_var = music_var,
            instrument = instrument,
            **kwargs
        )

    lilypond_library(
        name = name,
        deps = all_parts,
    )
