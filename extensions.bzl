load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _lilypond_impl(ctx):
  http_archive(
    name = "lilypond",
    urls = ["https://gitlab.com/lilypond/lilypond/-/releases/v2.25.19/downloads/lilypond-2.25.19-linux-x86_64.tar.gz"],
    integrity = "sha256-14QEF8MmuJ37dommY4i1CDTMdQO3JNtIHwUFDLztMwo=",
    strip_prefix = "lilypond-2.25.19",
    build_file = "BUILD.lilypond",
  )


lilypond = module_extension(
    implementation = _lilypond_impl,
)
