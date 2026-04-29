soprano = \relative c' {
    \clef treble
    \key f \major
    \time 2/2

    \cueDuringWithClef "bass" #DOWN #"bass" {
        <>^\markup { \tiny "Bass" }
        R1 |
    }
    f8 g a bes c r r4 |
    f,8 g a bes c4 c |
    f1\fermata \bar "|." |
}
