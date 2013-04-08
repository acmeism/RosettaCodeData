require 'open-uri'

anagram = nil

open('http://www.puzzlers.org/pub/wordlists/unixdict.txt') do |f|
  anagram = f.read.split.group_by {|s| s.each_char.sort}
end

count = anagram.each_value.map {|ana| ana.length}.max
anagram.each_value do |ana|
  if ana.length >= count
    p ana
  end
end
