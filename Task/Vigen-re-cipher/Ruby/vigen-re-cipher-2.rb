include VigenereCipher

plaintext = 'Beware the Jabberwock, my son! The jaws that bite, the claws that catch!'
key = 'Vigenere cipher'
ciphertext = VigenereCipher.encrypt(plaintext, key)
recovered  = VigenereCipher.decrypt(ciphertext, key)

puts "Original: #{plaintext}"
puts "Encrypted: #{ciphertext}"
puts "Decrypted: #{recovered}"
