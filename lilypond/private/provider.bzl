LilyPondProvider = provider(
    "Information provided by lilypond_library to renderer",
    fields = {
        "music_var": "Name of the variable that contains the music",
        "movement": "Name of the movement",
        "instrument": "Name of the instrument",
        "short_instrument": "Short name of the instrument",
        "quotes": "Map of music variables to their referenced names for \\addQuote",
        "includes": "depset of files that may be included",
        "renderables": "List of structs containing information about renderable deps",
        # renderables fields:
        #   name: Name of the renderable, used for naming output files
        #   renderable_file: depset of the file to render, without transitives
        #   transitive: depset of transitive files needed for rendering
    },
)
