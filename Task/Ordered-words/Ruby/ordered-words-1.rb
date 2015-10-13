require 'open-uri'
ordered_words = open('http://www.puzzlers.org/pub/wordlists/unixdict.txt', 'r').select do |word|
  word.strip!
  word.chars.sort.join == word
end

grouped = ordered_words.group_by &:size
puts grouped[grouped.keys.max]
