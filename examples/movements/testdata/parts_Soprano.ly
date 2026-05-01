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

\include "examples/movements/soprano-mvmt1-notes.ly"
\include "examples/movements/soprano-mvmt2-notes.ly"
\include "examples/movements/soprano-mvmt3-notes.ly"

\paper {

}

\header {
instrument = "Soprano"
composer = "Claude H. IV (and a half)"
title = "Movements of Grandeur"
    tagline = \markup {
        "LilyPond" #(lilypond-version) #scm-rev #scm-status
    }
}



\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Score.skipBars = ##t
        \sopranoMvmtOne
      }
    >>
  }
  \header { piece = "I - Andante" }
}
\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Score.skipBars = ##t
        \sopranoMvmtTwo
      }
    >>
  }
  \header { piece = "II - Scherzo" }
}
\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Score.skipBars = ##t
        \sopranoMvmtThree
      }
    >>
  }
  \header { piece = "III - Finale" }
}
