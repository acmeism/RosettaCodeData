val text = "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
val encoded = Vigenere.encrypt(text)
val decoded = Vigenere.decrypt(text)
println("Plain text => " + text)
println("Cipher text => " + encoded)
println("Decrypted => " + decoded)
