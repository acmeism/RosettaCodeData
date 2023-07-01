def caesarEncode(k, text) {
    def c = { (it*2)[k..(k+25)].join() }
    text.tr('a-zA-Z', c('a'..'z') + c('A'..'Z'))
}
def caesarDecode(cipherKey, text) { caesarEncode(26 - cipherKey, text) }
