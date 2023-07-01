set cypher [Vigenere new "Vigenere Cipher"]
set original "Beware the Jabberwock, my son! The jaws that bite, the claws that catch!"
set encrypted [$cypher encrypt $original]
set decrypted [$cypher decrypt $encrypted]
puts $original
puts "Encrypted: $encrypted"
puts "Decrypted: $decrypted"
