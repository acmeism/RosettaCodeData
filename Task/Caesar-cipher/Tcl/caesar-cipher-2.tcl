set caesar [Caesar new 3]
set txt "The five boxing wizards jump quickly."
set enc [$caesar encrypt $txt]
set dec [$caesar decrypt $enc]
puts "Original message  = $txt"
puts "Encrypted message = $enc"
puts "Decrypted message = $dec"
