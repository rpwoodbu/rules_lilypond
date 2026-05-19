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
\include "examples/movements/soprano-mvmt2-notes.ly"
\include "examples/movements/soprano-mvmt3-notes.ly"

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
instrument = "Soprano"
composer = "Claude H. IV (and a half)"
title = "Movements of Grandeur"
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
