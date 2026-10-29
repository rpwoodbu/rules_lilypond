trumpet_c = \relative c' {
    \key c \major
    \time 4/4

    \cueDuring "flute" #UP {
        <>^\markup { \tiny "Fl." }
        R1 |
    }
    \cueDuring "clarinet" #UP {
        <>^\markup { \tiny "Cl." }
        R1 |
    }
    c4 d e f |
    g1 \bar "|."
}
