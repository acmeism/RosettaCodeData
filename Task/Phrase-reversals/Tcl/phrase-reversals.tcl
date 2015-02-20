set s "rosetta code phrase reversal"
# Reverse all characters
puts [string reverse $s]
# Reverse characters in each word
puts [lmap word $s {string reverse $word}]
# Reverse the words but not the characters
puts [lreverse $s]
