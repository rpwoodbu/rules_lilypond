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

\include "examples/cues/theme.ly"
\include "examples/cues/flute.ly"

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
instrument = "Flute"
composer = "Anonymous"
title = "A Cue"
}

\addQuote "theme" { \theme }

\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Score.skipBars = ##t
        \flute
      }
    >>
  }
  \header { piece = "" }
}
