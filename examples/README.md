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

## Cues and cycles

To do cues which "quote" other parts, you would ordinarily depend on the `lilypond_library` that defines the cued notes. But sometimes two parts take cues from each other, creating a cycle which breaks Bazel. This example shows you how to deal with that.

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
