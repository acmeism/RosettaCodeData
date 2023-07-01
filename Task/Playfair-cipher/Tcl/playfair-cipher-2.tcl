Playfair create cypher "Playfair Example"
set plaintext "Hide the gold in...the TREESTUMP!!!"
set encoded [cypher encode $plaintext]
set decoded [cypher decode $encoded]
puts "Original: $plaintext"
puts "Encoded:  $encoded"
puts "Decoded:  $decoded"
