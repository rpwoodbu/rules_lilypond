# Examples

## Hello, World!

This is the simplest example which demonstrates the functionality of
programmatically-generated LilyPond books.

```sh
bazel build //examples/hello_world
```

## Multiple parts

Here's a short excerpt which demonstrates how to produce multiple parts and a full score.

```sh
bazel build //examples/three_parts:parts
bazel build //examples/three_parts:score
```

## Cues and cycles

To do cues which "quote" other parts, you would ordinarily depend on the `lilypond_library` that defines the cued notes. But sometimes two parts take cues from each other, creating a cycle which breaks Bazel. This example shows you how to deal with that.

```sh
bazel build //examples/cycles
```

## Stamp revision information

If you are tracking your music with an SCM (e.g. Git), you may want to stamp your PDFs with the revision number (e.g. commit SHA). This repository is already setup for this, so you can use it as an example. See the [.bazelrc](../.bazelrc) for the flags needed to enable stamping, and see the referenced [shell script](../tools/get_workspace_status.sh) which Bazel will run on each build to gather the information. Salt to taste.
