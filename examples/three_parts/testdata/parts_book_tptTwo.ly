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

\include "examples/three_parts/tpt2-notes.ly"

\paper {

}

\header {
instrument = "Trumpet II in Bb"
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
        \set Score.skipBars = ##t
        \tptTwo
      }
    >>
  }
  \header { piece = "" }
}
