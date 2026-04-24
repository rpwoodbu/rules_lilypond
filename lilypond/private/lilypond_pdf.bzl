load("//lilypond/private:provider.bzl", "LilyPondProvider")

_DERIVE_FROM_LABEL = "__DERIVE_FROM_LABEL__"

def _generate_pdf(ctx, name, src, deps):
    pdf = ctx.actions.declare_file(name)

    args = ctx.actions.args()
    args.add("--pdf")
    # LilyPond wants to add the extension itself.
    args.add("--output", _strip_extension(pdf))
    if ctx.attr.verbose:
        args.add("--verbose")
    else:
        args.add("--loglevel=WARN")
    args.add("--include", ctx.workspace_name)
    args.add(src)

    ctx.actions.run(
        outputs = [pdf],
        inputs = depset(
            [src],
            transitive = [d[LilyPondProvider].includes for d in deps],
        ),
        executable = ctx.executable._lilypond,
        arguments = [args],
        # Prevents `fontconfig` complaining about unwritable cache dir.
        env = {"HOME": "/tmp"},
        mnemonic = "LilyPondPDF",
        progress_message = "Rendering LilyPond PDF %{output}",
    )

    return pdf

def _lilypond_pdf_impl(ctx):
    def gen_name(index, plural):
        if plural:
            return "{}_{}.pdf".format(ctx.attr.name, index)
        return "{}.pdf".format(ctx.attr.name)

    pdfs = []
    if ctx.attr.srcs:
        for src in ctx.files.srcs:
            name = gen_name(len(pdfs), len(ctx.files.srcs) > 1)
            pdfs.append(_generate_pdf(ctx, name, src, ctx.attr.deps))
    else:
        for dep in ctx.attr.deps:
            if len(dep.files.to_list()) != 1:
                fail("Cannot render deps that are not single-src.")
            name = gen_name(len(pdfs), len(ctx.attr.deps) > 1)
            pdfs.append(_generate_pdf(ctx, name, dep.files.to_list()[0], [dep]))

    return DefaultInfo(files=depset(pdfs))

def _strip_extension(file):
    """Returns path of File `file` without any extension."""
    ext_len = len(file.extension)
    if ext_len == 0:
        return file.path
    ext_len += 1  # Also strip the dot.
    return file.path[:-ext_len]

lilypond_pdf = rule(
    doc = """Create PDFs from LilyPond files or `lilypond_library` deps.

If you use `srcs`, then each source will be rendered as a separate PDF, using
all `deps` for each of them. If you only use `deps`, then each dep will be rendered
as a separate PDF, using only the transitive deps of the dep being rendered. The
former is good for ease-of-use in small projects, but the latter preserves
incrementality and is preferred.
""",
    implementation = _lilypond_pdf_impl,
    attrs = {
        "srcs": attr.label_list(
            doc = "LilyPond files to render.",
            allow_files = [".ly"],
        ),
        "deps": attr.label_list(
            doc = "Libs to render, or if `srcs` is provided, deps needed to " +
                  "render those files.",
            providers = [LilyPondProvider],
        ),
        "verbose": attr.bool(default = False),
        "_lilypond": attr.label(
            cfg = "exec",
            executable = True,
            default = "@lilypond",
        ),
    },
)
