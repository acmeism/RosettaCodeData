package require Tk
proc sendMacro {w string} {
    foreach c [split $string {}] {
        # Will not work for “<” character...
        event generate $w $c
    }
}
proc macro {key translation} {
    bind . <$key> [list sendMacro %W [string map {% %%} $translation]]
}

# Some demonstration macros
macro F1 "Help me!"
macro F2 "You pressed the F2 key"
macro F3 "I'm getting bored here..."
pack [text .t];   # A place for you to test the macros
