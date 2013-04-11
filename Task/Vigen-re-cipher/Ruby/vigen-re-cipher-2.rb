vc = VigenereCipher.new('Vigenere cipher')
plaintext = 'Beware the Jabberwock, my son! The jaws that bite, the claws that catch!'
ciphertext = vc.encrypt(plaintext)
recovered  = vc.decrypt(ciphertext)
puts "Original: #{plaintext}"
puts "Encrypted: #{ciphertext}"
puts "Decrypted: #{recovered}"
