require 'open-uri'

anagram = Hash.new {|hash, key| hash[key] = []} # map sorted chars to anagrams

open('http://www.puzzlers.org/pub/wordlists/unixdict.txt') do |f|
  words = f.read.split
  for word in words
    anagram[word.split('').sort] << word
  end
end

count = anagram.values.map {|ana| ana.length}.max
anagram.each_value do |ana|
  if ana.length >= count
    p ana
  end
end
