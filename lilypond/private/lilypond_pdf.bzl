load("//lilypond/private:provider.bzl", "LilyPondProvider")

def _lilypond_pdf_impl(ctx):
    if len(ctx.attr.srcs) != 1:
        fail("Can only specify one file in srcs of lilypond_pdf.")

    pdf = ctx.actions.declare_file(ctx.attr.name + ".pdf")
    args = ctx.actions.args()
    args.add("--pdf")
    # LilyPond wants to add the extension itself.
    args.add("--output", _strip_extension(pdf))
    if ctx.attr.verbose:
        args.add("--verbose")
    else:
        args.add("--loglevel=WARN")
    args.add("--include", ctx.workspace_name)
    args.add_all(ctx.files.srcs)
    ctx.actions.run(
        outputs = [pdf],
        inputs = depset(
            ctx.files.srcs,
            transitive = [d[LilyPondProvider].includes for d in ctx.attr.deps],
        ),
        executable = ctx.executable._lilypond,
        arguments = [args],
        mnemonic = "LilyPondPDF",
        progress_message = "Rendering LilyPond PDF %{label}",
    )
    return DefaultInfo(files=depset([pdf]))

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
            allow_empty = False,
            allow_files = True,
        ),
        "deps": attr.label_list(
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
