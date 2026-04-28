LilyPondProvider = provider(
    "Information provided by lilypond_library to renderer",
    fields = {
        "music_var": "Name of the variable that contains the music",
        "movement": "Name of the movement",
        "instrument": "Name of the instrument",
        "short_instrument": "Short name of the instrument",
        "includes": "depset of files that may be included",
    },
)
