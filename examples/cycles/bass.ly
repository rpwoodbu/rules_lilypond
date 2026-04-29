bass = \relative c, {
    \clef bass
    \key f \major
    \time 2/2

    f8 g a bes c r r4 |
    \cueDuringWithClef "soprano" #DOWN #"treble" {
        <>^\markup { \tiny "Sop." }
        R1 |
    }
    f,8 g a bes c4 c |
    f,1\fermata \bar "|." |
}
