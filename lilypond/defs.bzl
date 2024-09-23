load("//lilypond/private:lilypond_library.bzl", _lilypond_library = "lilypond_library")
load("//lilypond/private:lilypond_parts.bzl", _lilypond_parts = "lilypond_parts")
load("//lilypond/private:lilypond_pdf.bzl", _lilypond_pdf = "lilypond_pdf")
load("//lilypond/private:lilypond_score.bzl", _lilypond_score = "lilypond_score")

lilypond_library = _lilypond_library
lilypond_parts = _lilypond_parts
lilypond_pdf = _lilypond_pdf
lilypond_score = _lilypond_score
