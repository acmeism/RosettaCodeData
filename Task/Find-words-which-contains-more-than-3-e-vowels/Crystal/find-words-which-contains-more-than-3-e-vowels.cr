# You could say that the "y" in "erlenmeyer" isn't a vowel
# but the one in "everywhere" definitely is.
# So I'm adding "y" to the "non-'e'-vowel" set, and in any
# case this solution will be as wrong as the others, only
# on the opposite side.

File.new("unixdict.txt").each_line do |word|
  puts word if word.count("e") > 3 && word.count("aiouy") == 0
end
