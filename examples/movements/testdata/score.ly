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

\include "examples/movements/soprano-mvmt1-notes.ly"
\include "examples/movements/bass-mvmt1-notes.ly"
\include "examples/movements/soprano-mvmt2-notes.ly"
\include "examples/movements/bass-mvmt2-notes.ly"
\include "examples/movements/soprano-mvmt3-notes.ly"
\include "examples/movements/bass-mvmt3-notes.ly"

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
composer = "Claude H. IV (and a half)"
title = "Movements of Grandeur"
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
