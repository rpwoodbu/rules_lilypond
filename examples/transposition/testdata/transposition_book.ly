\version "2.26.0"

#(define scm-rev
   (let ((val (getenv "BUILD_SCM_REVISION")))
     (if val
         (string-append "- Revision " val)
         "")))

#(define scm-short-rev
   (let ((val (getenv "BUILD_SCM_SHORT_REVISION")))
     (if val
         val
         "")))

#(define scm-status
   (let ((val (getenv "BUILD_SCM_STATUS")))
     (if (and val (string=? val "Modified"))
         (string-append "(" val ")")
         "")))

customLastPageFooter = \markup \fill-line {
    \line { "LilyPond" #(lilypond-version) #scm-rev #scm-status }
}

customFooter = \markup \line { #scm-short-rev #scm-status }

\include "examples/transposition/flute.ly"
\include "examples/transposition/clarinet.ly"
\include "examples/transposition/trumpet_c.ly"
\include "examples/transposition/trumpet_bb.ly"

\paper {
    oddFooterMarkup = \markup {
        \if \on-last-page \customLastPageFooter
        \unless \on-last-page \teeny \fill-line {
            \line {}
            \line {}
            \customFooter
        }
    }

    evenFooterMarkup = \markup {
        \if \on-last-page \customLastPageFooter
        \unless \on-last-page \teeny \fill-line {
            \customFooter
            \line {}
            \line {}
        }
    }


}

\header {
composer = "Anonymous"
title = "Transposition"
}

\addQuote "flute" { \transposition c' \flute }
\addQuote "clarinet" { \transposition bes \clarinet }

\score {
  {
    \new StaffGroup <<
      \new Staff \with { \transposition c' } {
        \set Staff.instrumentName = "Flute"
        \set Staff.shortInstrumentName = ""
        \flute
      }
      \new Staff \with { \transposition bes } {
        \set Staff.instrumentName = "Clarinet in Bb"
        \set Staff.shortInstrumentName = ""
        \clarinet
      }
      \new Staff \with { \transposition c' } {
        \set Staff.instrumentName = "Trumpet I in C"
        \set Staff.shortInstrumentName = ""
        \trumpet_c
      }
      \new Staff \with { \transposition bes } {
        \set Staff.instrumentName = "Trumpet I in Bb"
        \set Staff.shortInstrumentName = ""
        \trumpet_bb
      }
    >>
  }
  \header { piece = "" }
}
