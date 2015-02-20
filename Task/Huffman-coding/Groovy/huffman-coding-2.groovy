def message = "this is an example for huffman encoding"

def codeTable = huffmanCode(message)
codeTable.each { k, v -> println "$k: $v" }

def encoded = encode(message, codeTable)
println encoded

def decoded = decode(encoded, codeTable)
println decoded
