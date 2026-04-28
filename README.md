# `rules_lilypond`

**[Bazel](https://bazel.build/) rules for [LilyPond](https://lilypond.org/)**

## Why?

### Hermeticity

LilyPond is very sensitive to which version you use, even when using the `\version` statement. `rules_lilypond` downloads a precise version of LilyPond (see [extensions.bzl](extensions.bzl) for which one) and executes it hermetically, ensuring that you always use the version you mean to use, even if coming back to your project months or years later.

**You don't even need to have LilyPond or Bazel installed on your machine!** All you need is [Bazelisk](https://github.com/bazelbuild/bazelisk) (a small Bazel launcher).

### Incrementality

When working with larger projects, it saves time to use a proper build system so that only the parts which need to be rebuilt will be.

### Boilerplate

In order to produce numerous parts and scores, there is a lot of boilerplate and repetitive configuration. `rules_lilypond` allows you to generate these files programmatically based on attributes in Bazel rules.

## Quickstart

> [!NOTE]
> If you're not familiar with [Bazel](https://bazel.build/), install [Bazelisk](https://github.com/bazelbuild/bazelisk) (a small Bazel launcher), create a new directory, and just place the files from the following instructions in that directory.

`rules_bazel` is not in the [Bazel Central Registry](https://registry.bazel.build/) (yet), so we need to use `archive_override`. Put this in your `MODULE.bazel`:

```python
bazel_dep(name = "rules_lilypond", version = "0.0.3")

archive_override(
    module_name = "rules_lilypond",
    urls = ["https://github.com/rpwoodbu/rules_lilypond/archive/58d49fdbdb2ba7981dd0139ee3d01ebd29d250a0.tar.gz"],
    integrity = "sha256-DCKCWXCOcVrBXTSOzgKVhl7ILa5uAtF7Nv5Ih4UwRVc=",
    strip_prefix = "rules_lilypond-58d49fdbdb2ba7981dd0139ee3d01ebd29d250a0",
)
```

To render a PDF from an `.ly` file, put this in your `BUILD.bazel`:

```python
load("@rules_lilypond//lilypond:defs.bzl", "lilypond_pdf")

lilypond_pdf(
    name = "my_music",
    srcs = ["my_music.ly"],
)
```

Put some music in `my_music.ly` (might I suggest `{ \clef bass c d e f g a b c' }`), then run:

```sh
bazel build :my_music
```

_Et voilà_, **without ever installing Bazel or LilyPond**, it will **download what is specified**, build your music, then output something like this:

```
INFO: Invocation ID: ed11ff2b-c518-40e3-a6f8-2b0cae3014da
INFO: Analyzed target //:my_music (0 packages loaded, 0 targets configured).
INFO: Found 1 target...
Target //:my_music up-to-date:
  bazel-bin/my_music.pdf
INFO: Elapsed time: 1.037s, Critical Path: 0.84s
INFO: 2 processes: 1 internal, 1 linux-sandbox.
INFO: Build completed successfully, 2 total actions
``` 

> [!NOTE]
> Warnings are errors by default. If you get an error about the `\version` statement missing, simply put it in your `.ly` file and try again.

Find your new PDF file at the file path noted in the output.

### Pin the version of Bazel

As an additional step, it is highly recommended to pin the version of Bazel itself. Run `bazel version` to see which you are currently running, then place that number (no leading `v`) into a file `.bazelversion`. Then Bazelisk will always execute that version of Bazel. Now you have complete hermeticity.

## Generating parts and scores (aka books)

This is one of the more fiddly bits of LilyPond: creating a separate book for each part, and one for the score. `rules_lilypond` can help.

There is a rule `lilypond_book` which synthesizes an `.ly` file from one or more "notes" variables taken as dependencies. There is a rule `lilypond_library` so that you can define these dependencies (and their dependencies, e.g. for cues or utilities), which will be `\include`d into the file synthesized by any and all `lilypond_book`s that depend on them. There's also a macro `lilypond_parts_pdfs` which can generate all the `lilypond_book` targets in one go; it also produces a single `lilypond_pdf` target which produces a separate PDF for each book, while still only rebuilding the ones which changed since the last build.

The end result is a directory containing `.ly` files with only notes in them, plus a concise `BUILD.bazel` file which includes a target that incrementally builds a PDF for every part in your project.

To see all this in action, look at the [examples](examples/).
