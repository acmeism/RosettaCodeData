SubCipher create sc
set text [read [open /etc/motd]]
puts "Original:\n$text\n----\n"
puts "Ciphered:\n[set cipher [sc enc $text]]\n----\n"
puts "Decrypted:\n[sc dec $cipher]\n----\n"
puts "Key:\n[sc key]\n----\n"
