def caesarEncode(​cipherKey, text) {
    def builder = new StringBuilder()
    text.each { character ->
        int ch = character[0] as char
        switch(ch) {
            case 'a'..'z': ch = ((ch - 97 + cipherKey) % 26 + 97); break
            case 'A'..'Z': ch = ((ch - 65 + cipherKey) % 26 + 65); break
        }
        builder << (ch as char)
    }
    builder as String
}
def caesarDecode(cipherKey, text) { caesarEncode(26 - cipherKey, text) }
