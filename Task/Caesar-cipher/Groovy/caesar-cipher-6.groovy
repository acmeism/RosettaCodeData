def plainText = "The Quick Brown Fox jumped over the lazy dog"
def cipherKey = 12
def cipherText = caesarEncode(cipherKey, plainText)
def decodedText = caesarDecode(cipherKey, cipherText)

println "plainText: $plainText"
println "cypherText($cipherKey): $cipherText"
println "decodedText($cipherKey): $decodedText"

assert  plainText == decodedText
