val text = "ATTACKATDAWN"
val myVigenere = new Vigenere("LEMON")
val encoded = text.map(c => myVigenere.encode(c))
println("Plaintext => " + text)
println("Ciphertext => " + encoded)
println("Decrypted => " + encoded.map(c => myVigenere.decode(c)))
