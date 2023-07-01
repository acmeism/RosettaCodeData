def rot13 = { String s ->
    (s as List).collect { ch ->
        switch (ch) {
            case ('a'..'m') + ('A'..'M'):
                return (((ch as char) + 13) as char)
            case ('n'..'z') + ('N'..'Z'):
                return (((ch as char) - 13) as char)
            default:
                return ch
        }
    }.inject ("") { string, ch -> string += ch}
}
