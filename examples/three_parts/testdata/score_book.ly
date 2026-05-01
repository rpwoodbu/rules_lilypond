\version "2.26.0"

#(define scm-rev
   (let ((val (getenv "BUILD_SCM_REVISION")))
     (if val
         (string-append "- Revision " val)
         "")))

#(define scm-status
   (let ((val (getenv "BUILD_SCM_STATUS")))
     (if (and val (string=? val "Modified"))
         (string-append "(" val ")")
         "")))

\include "examples/three_parts/tpt1-notes.ly"
\include "examples/three_parts/tpt2-notes.ly"
\include "examples/three_parts/tpt3-notes.ly"

\paper {

}

\header {
composer = "Gustav Mahler"
title = "Excerpt from the 7th Symphony"
    tagline = \markup {
        "LilyPond" #(lilypond-version) #scm-rev #scm-status
    }
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
