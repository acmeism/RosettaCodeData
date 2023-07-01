val text="The five boxing wizards jump quickly"
println("Plaintext  => " + text)
val encoded=Caesar.encode(text, 3)
println("Ciphertext => " + encoded)
println("Decrypted  => " + Caesar.decode(encoded, 3))
