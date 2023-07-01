val text = "The five boxing wizards jump quickly"
val myCaeser = new Caeser(3)
val encoded = text.map(c => myCaeser.encode(c))
println("Plaintext => " + text)
println("Ciphertext => " + encoded)
println("Decrypted => " + encoded.map(c => myCaeser.decode(c)))
