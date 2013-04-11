bind . <F1> {
    foreach c [split "Macro demo!" {}] {
        event generate %W $c
    }
}
