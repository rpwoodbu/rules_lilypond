\version "{VERSION}"

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

{INCLUDES}

\paper {
{PAPER}
}

\header {
{HEADER}
    tagline = \markup {
        "LilyPond" #(lilypond-version) #scm-rev #scm-status
    }
}

{QUOTES}

{SCORES}
