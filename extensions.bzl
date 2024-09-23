load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

LILYPOND_VERSION = "2.25.19"

def _lilypond_impl(ctx):
  http_archive(
    name = "lilypond",
    urls = ["https://gitlab.com/lilypond/lilypond/-/releases/v{version}/downloads/lilypond-{version}-linux-x86_64.tar.gz".format(version = LILYPOND_VERSION)],
    integrity = "sha256-14QEF8MmuJ37dommY4i1CDTMdQO3JNtIHwUFDLztMwo=",
    strip_prefix = "lilypond-{}".format(LILYPOND_VERSION),
    build_file = "BUILD.lilypond",
  )


lilypond = module_extension(
    implementation = _lilypond_impl,
)
