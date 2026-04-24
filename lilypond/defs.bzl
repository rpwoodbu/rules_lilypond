load("//lilypond/private:lilypond_book.bzl", _lilypond_book = "lilypond_book")
load("//lilypond/private:lilypond_library.bzl", _lilypond_library = "lilypond_library")
load("//lilypond/private:lilypond_parts_pdfs.bzl", _lilypond_parts_pdfs = "lilypond_parts_pdfs")
load("//lilypond/private:lilypond_pdf.bzl", _lilypond_pdf = "lilypond_pdf")

lilypond_library = _lilypond_library
lilypond_book = _lilypond_book
lilypond_parts_pdfs = _lilypond_parts_pdfs
lilypond_pdf = _lilypond_pdf
