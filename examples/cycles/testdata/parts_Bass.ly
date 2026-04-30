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

\include "examples/cycles/bass.ly"
\include "examples/cycles/soprano.ly"

\paper {

}

\header {
instrument = "Bass"
composer = "Anonymous (or maybe Holst)"
title = "Cycles"
    tagline = \markup {
        "LilyPond" #(lilypond-version) #scm-rev #scm-status
    }
}

\addQuote "soprano" { \soprano }

\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Score.skipBars = ##t
        \bass
      }
    >>
  }
  \header { piece = "" }
}
