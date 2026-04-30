load("//lilypond/private:provider.bzl", "LilyPondProvider")
load("//:extensions.bzl", "LILYPOND_VERSION")

# Common logic for generating scores and parts.
def _generate_book(ctx, name, includes, movement_dep_map, instrument, quotes):
    header = []
    if instrument:
        header.append('instrument = "{}"'.format(instrument))
    if ctx.attr.composer:
        header.append('composer = "{}"'.format(ctx.attr.composer))
    if ctx.attr.title:
        header.append('title = "{}"'.format(ctx.attr.title))
    if ctx.attr.subtitle:
        header.append('subtitle = "{}"'.format(ctx.attr.subtitle))

    subs = ctx.actions.template_dict()
    subs.add("{VERSION}", LILYPOND_VERSION)
    subs.add("{INCLUDES}", "\n".join(['\\include "{}"'.format(i) for i in includes]))
    subs.add("{PAPER}", "\n".join(ctx.attr.paper))
    subs.add("{HEADER}", "\n".join(header))
    subs.add("{QUOTES}", "\n".join(
        ['\\addQuote "{}" {{ \\{} }}'.format(ref, music) for music, ref in quotes.items()]))

    scores = []
    for movement, deps in movement_dep_map.items():
        scores.extend([
            '\\score {',
            '  {',
            '    \\new StaffGroup <<',
        ])

        for dep in deps:
            if ctx.attr.staff_with:
                scores.append('      \\new Staff \\with {{ {} }} {{'.format(ctx.attr.staff_with))
            else:
                scores.append('      \\new Staff {')
            if ctx.attr.skip_bars:
                scores.append('        \\set Score.skipBars = ##t') 
            else:
                scores.append('        \\set Staff.instrumentName = "{}"'.format(dep[LilyPondProvider].instrument))
                short_name = dep[LilyPondProvider].short_instrument
                if short_name != None:
                    scores.append('        \\set Staff.shortInstrumentName = "{}"'.format(short_name))

            scores.extend(ctx.attr.staff)
            scores.extend([
                '        \\{}'.format(dep[LilyPondProvider].music_var),
                '      }',
            ])

        scores.extend([
            '    >>',
            '  }',
            '  \\header {{ piece = "{}" }}'.format(movement),
            '}',
        ])

    subs.add("{SCORES}", "\n".join(scores))

    out = ctx.actions.declare_file(name + ".ly")
    ctx.actions.expand_template(
        output = out,
        template = ctx.file.template,
        computed_substitutions = subs,
    )

    return out

# Generate a full score containing all parts.
def _generate_score(ctx):
    includes_depsets = [d[LilyPondProvider].includes for d in ctx.attr.deps]
    includes = [i.path for ds in includes_depsets for i in ds.to_list()]

    movement_dep_map = {}
    instruments = set()
    quotes = {}
    for dep in ctx.attr.deps:
        movement_dep_map.setdefault(dep[LilyPondProvider].movement, []).append(dep)
        instrument = dep[LilyPondProvider].instrument
        if instrument:
            instruments.add(instrument)
        quotes.update(dep[LilyPondProvider].quotes)

    instrument = None
    if ctx.attr.instrument:
       instrument = ctx.attr.instrument 
    elif len(instruments) == 1:
        # This is a single part. Show the instrument name.
        instrument = instruments.pop()

    out = _generate_book(
        ctx, ctx.attr.name, includes, movement_dep_map, instrument, quotes)
    return [
        DefaultInfo(files = depset([out])),
        LilyPondProvider(
            includes = depset(transitive = includes_depsets),
            renderables = [struct(
                name = ctx.attr.name,
                renderable_file = depset([out]),
                transitive = depset(transitive = includes_depsets),
            )],
        ),
    ]

# Generate a separate book for each part. Each book will contain all movements
# for that part.
def _generate_parts(ctx):
    if ctx.attr.instrument:
        fail("Cannot specify instrument name when generating parts.")

    if ctx.attr.instrument:
        fail("Cannot specify instrument name when generating parts.")

    instrument_movement_dep_map = {}
    for dep in ctx.attr.deps:
        if dep[LilyPondProvider].music_var == "":
            continue
        instrument_movement_dep_map \
            .setdefault(dep[LilyPondProvider].instrument, {}) \
            .setdefault(dep[LilyPondProvider].movement, []) \
            .append(dep)

    books = []
    renderables = []
    for instrument, movement_dep_map in instrument_movement_dep_map.items():
        includes_depset = depset(
            transitive = [d[LilyPondProvider].includes for deps in movement_dep_map.values() for d in deps])
        quotes = {}
        name = instrument.replace(" ", "_")
        for deps in movement_dep_map.values():
            for dep in deps:
                quotes.update(dep[LilyPondProvider].quotes)
        book = _generate_book(
            ctx,
            "{}_{}".format(ctx.attr.name, name),
            [i.path for i in includes_depset.to_list()],
            movement_dep_map,
            instrument,
            quotes = quotes,
        )
        books.append(book)
        renderables.append(struct(
            name = name,
            renderable_file = depset([book]),
            transitive = includes_depset,
        ))

    return [
        DefaultInfo(files = depset(books)),
        LilyPondProvider(
            renderables = renderables,
        ),
    ]

def _lilypond_book_impl(ctx):
    if ctx.attr.parts:
        return _generate_parts(ctx)
    else:
        return _generate_score(ctx)

lilypond_book = rule(
    doc = """Generates a LilyPond "book" file.""",
    implementation = _lilypond_book_impl,
    attrs = {
        "instrument": attr.string(
            doc = "Override name of instrument. Usually the instrument name " +
                  "flows from the `lilypond_library`, but this is useful " +
                  "when combining parts into a single book. Cannot be used " +
                  "if `parts` is True. ",
        ),
        "composer": attr.string(
            doc = "Name of composer.",
        ),
        "title": attr.string(
            doc = "Title of piece.",
        ),
        "subtitle": attr.string(
            doc = "Subtitle of piece.",
        ),
        "parts": attr.bool(
            doc = "Whether to generate separate books for each part. If " +
                  "False, a single book (full score) will be generated.",
            default = False,
        ),
        "skip_bars": attr.bool(
            doc = "Whether to produce multimeasure rests. Set this to " +
                  "`False` for full scores.",
            default = True,
        ),
        "paper": attr.string_list(
            doc = "List of settings for \\paper.",
        ),
        "staff": attr.string_list(
            doc = "List of settings for each \\staff.",
        ),
        "staff_with": attr.string(
            doc = "Items to place in \\with stanza when creating \\new Staff.",
        ),
        "deps": attr.label_list(
            providers = [LilyPondProvider],
        ),
        "template": attr.label(
            allow_single_file = [".ly.tpl"],
            default = "//lilypond:book.ly.tpl",
            doc = "Template for generating LilyPond book."
        ),
    },
)
