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

\include "examples/hello_world/hello_world.ly"

\paper {

}

\header {
instrument = "Theremin I"
composer = "Anonymous"
title = "Hello, World!"
    tagline = \markup {
        "LilyPond" #(lilypond-version) #scm-rev #scm-status
    }
}



\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Score.skipBars = ##t
        \helloWorldNotes
      }
    >>
  }
  \header { piece = "" }
}
