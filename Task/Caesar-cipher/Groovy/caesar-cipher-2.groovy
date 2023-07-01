def caesarEncode(cipherKey, text) {
    text.chars.collect { c ->
        int off = c.isUpperCase() ? 'A' : 'a'
        c.isLetter() ? (((c as int) - off + cipherKey) % 26 + off) as char : c
    }.join()
}
def caesarDecode(cipherKey, text) { caesarEncode(26 - cipherKey, text) }
