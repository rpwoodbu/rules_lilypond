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
\include "examples/movements/bass-mvmt1-notes.ly"
\include "examples/movements/soprano-mvmt2-notes.ly"
\include "examples/movements/bass-mvmt2-notes.ly"
\include "examples/movements/soprano-mvmt3-notes.ly"
\include "examples/movements/bass-mvmt3-notes.ly"

\paper {

}

\header {
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
        \set Staff.instrumentName = "Soprano"
        \set Staff.shortInstrumentName = ""
        \sopranoMvmtOne
      }
      \new Staff {
        \set Staff.instrumentName = "Bass"
        \set Staff.shortInstrumentName = ""
        \bassMvmtOne
      }
    >>
  }
  \header { piece = "I - Andante" }
}
\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Staff.instrumentName = "Soprano"
        \set Staff.shortInstrumentName = ""
        \sopranoMvmtTwo
      }
      \new Staff {
        \set Staff.instrumentName = "Bass"
        \set Staff.shortInstrumentName = ""
        \bassMvmtTwo
      }
    >>
  }
  \header { piece = "II - Scherzo" }
}
\score {
  {
    \new StaffGroup <<
      \new Staff {
        \set Staff.instrumentName = "Soprano"
        \set Staff.shortInstrumentName = ""
        \sopranoMvmtThree
      }
      \new Staff {
        \set Staff.instrumentName = "Bass"
        \set Staff.shortInstrumentName = ""
        \bassMvmtThree
      }
    >>
  }
  \header { piece = "III - Finale" }
}
