def caesarEncode(k, text) {
    text.tr('a-zA-Z', ((('a'..'z')*2)[k..(k+25)] + (('A'..'Z')*2)[k..(k+25)]).join())
}
def caesarDecode(cipherKey, text) { caesarEncode(26 - cipherKey, text) }
