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

\include "examples/three_parts/tpt1-notes.ly"
\include "examples/three_parts/tpt2-notes.ly"
\include "examples/three_parts/tpt3-notes.ly"

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
composer = "Gustav Mahler"
title = "Excerpt from the 7th Symphony"
}



\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Staff.instrumentName = "Trumpet I in Bb"
        \set Staff.shortInstrumentName = "Tpt I"
        \tptOne
      }
      \new Staff {
        \set Staff.instrumentName = "Trumpet II in Bb"
        \set Staff.shortInstrumentName = "Tpt II"
        \tptTwo
      }
      \new Staff {
        \set Staff.instrumentName = "Trumpet III in Bb"
        \set Staff.shortInstrumentName = "Tpt III"
        \tptThree
      }
    >>
  }
  \header { piece = "" }
}
