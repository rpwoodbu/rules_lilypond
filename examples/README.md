# Examples

## Hello, World!

This is the simplest example which demonstrates the functionality of
programmatically-generated LilyPond books.

```sh
bazel build //examples/hello_world
```

[See the result.](https://rpwoodbu.github.io/rules_lilypond/hello_world.pdf)

## Multiple parts

Here's a short excerpt which demonstrates how to produce multiple parts and a full score.

```sh
bazel build //examples/three_parts:parts
bazel build //examples/three_parts:score
```

See the results:
- [Score](https://rpwoodbu.github.io/rules_lilypond/score.pdf)
- Parts:
    - [Trumpet I in Bb](https://rpwoodbu.github.io/rules_lilypond/parts_Trumpet_I_in_Bb.pdf)
    - [Trumpet II in Bb](https://rpwoodbu.github.io/rules_lilypond/parts_Trumpet_II_in_Bb.pdf)
    - [Trumpet III in Bb](https://rpwoodbu.github.io/rules_lilypond/parts_Trumpet_III_in_Bb.pdf)

## Movements

When working with pieces having multiple movements, put each part and movement
in a separate file, and define a `lilypond_library` for each, annotated with the
movement name. Add them as deps to `lilypond_book` in movement order.

```sh
bazel build //examples/movements
```

See the results:
- [Score](https://rpwoodbu.github.io/rules_lilypond/movements_score.pdf)
- Parts:
    - [Soprano](https://rpwoodbu.github.io/rules_lilypond/movements_Soprano.pdf)
    - [Bass](https://rpwoodbu.github.io/rules_lilypond/movements_Bass.pdf)

## Cues

To cue ("quote") music from another part, add the library that defines the quoted music as a dependency. Its quote definitions are inherited by the dependent library, so the resulting book includes the corresponding `\addQuote` statement.

```sh
bazel build //examples/cues
```

[See the result.](https://rpwoodbu.github.io/rules_lilypond/cues.pdf)

The [publish-examples workflow](../.github/workflows/publish-examples.yml)
publishes the PDF to GitHub Pages when changes are pushed to `main`.

## Transposition

The same trumpet part, written in C, can be used for both C and B-flat trumpet
by overriding its transposition in downstream libraries. Its cues quote flute
music in C and clarinet music in B-flat; each `\addQuote` includes the source
part's transposition so the cues sound at the correct pitch.

```sh
bazel build //examples/transposition
```

[See the result.](https://rpwoodbu.github.io/rules_lilypond/transposition.pdf)

## Cyclic cues

When two parts cue each other, depending on each other's libraries creates a cycle that Bazel cannot build. The cycles example avoids this by putting both parts' music files in each library and defining each part's quote locally.

```sh
bazel build //examples/cycles
```

See the results:
- [Soprano](https://rpwoodbu.github.io/rules_lilypond/cycles_Soprano.pdf)
- [Bass](https://rpwoodbu.github.io/rules_lilypond/cycles_Bass.pdf)

# Tips and tricks

## No "point-and-click" when building with `-c opt`

When building the final PDFs (i.e., a release build), use `bazel build -c opt`. This will prevent those "point-and-click" links from being embedded in the PDFs. While useful for debugging, those links are not helpful when distributing files, can include private information, and can interfere with page turning when used with digital music displays.

## Stamp revision information

If you are tracking your music with an SCM (e.g. Git), you may want to stamp your PDFs with the revision number (e.g. commit SHA). This repository is already setup for this, so you can use it as an example. See the [.bazelrc](../.bazelrc) for the flags needed to enable stamping, and see the referenced [shell script](../tools/get_workspace_status.sh) which Bazel will run on each build to gather the information. Salt to taste.
