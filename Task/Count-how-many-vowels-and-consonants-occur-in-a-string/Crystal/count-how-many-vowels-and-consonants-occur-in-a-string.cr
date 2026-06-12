def count_vowels_and_consonants (s, unique=false)
  s = s.downcase
  vowels = s.delete("^aeiou")
  consonants = s.delete("^b-df-hj-np-tv-z")
  return { vowels.size, consonants.size } unless unique
  { vowels.chars.to_set.size, consonants.chars.to_set.size }
end

def test (s)
  puts "String: #{s}"
  tv, tc = count_vowels_and_consonants s
  uv, uc = count_vowels_and_consonants s, unique: true
  puts "  %2d unique vowels,     %2d total" % {uv, tv}
  puts "  %2d unique consonants, %2d total" % {uc, tc}
end

test "Now is the time for all good men to come to the aid of their country."
puts
test "Count how many vowels and consonants occur in a string"
puts
test "A man, a plan, a canal -- Panama!"
