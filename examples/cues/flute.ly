flute = \relative c'' {
    \clef treble
    \key c \major
    \time 4/4

    \cueDuring "theme" #DOWN {
        <>_\markup { \tiny "Theme" }
        R1 |
    }
    c4 d e f |
    \bar "|."
}
