load("//lilypond/private:provider.bzl", "LilyPondProvider")

_DERIVE_FROM_LABEL = "__DERIVE_FROM_LABEL__"

def _lilypond_pdf_impl(ctx):
    srcs = ctx.files.srcs + ctx.files.deps
    out_prefix = ctx.attr.out_prefix
    if out_prefix == _DERIVE_FROM_LABEL:
        out_prefix = "{}.".format(ctx.attr.name)
    pdfs = []

    for src in srcs:
        name = "{}{}".format(out_prefix, src.basename)
        if name.endswith(".ly"):
            name = name[:-3]
        pdf = ctx.actions.declare_file("{}.pdf".format(name))
        pdfs.append(pdf)

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
                transitive = [d[LilyPondProvider].includes for d in ctx.attr.deps],
            ),
            executable = ctx.executable._lilypond,
            arguments = [args],
            mnemonic = "LilyPondPDF",
            progress_message = "Rendering LilyPond PDF %{{label}} ({})".format(name),
        )

    return DefaultInfo(files=depset(pdfs))

def _strip_extension(file):
    """Returns path of File `file` without any extension."""
    ext_len = len(file.extension)
    if ext_len == 0:
        return file.path
    ext_len += 1  # Also strip the dot.
    return file.path[:-ext_len]

lilypond_pdf = rule(
    implementation = _lilypond_pdf_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = True,
            allow_files = True,
        ),
        "deps": attr.label_list(
            providers = [LilyPondProvider],
        ),
        "out_prefix": attr.string(
            default = _DERIVE_FROM_LABEL,
            doc = "Prefix to apply to output files.",
        ),
        "verbose": attr.bool(default = False),
        "_lilypond": attr.label(
            cfg = "exec",
            executable = True,
            default = "@lilypond",
        ),
    },
)
