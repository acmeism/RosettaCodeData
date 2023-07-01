def deranged?(a, b)
  a.chars.zip(b.chars).all? {|char_a, char_b| char_a != char_b}
end

def find_derangements(list)
  list.combination(2) {|a,b| return a,b  if deranged?(a,b)}
  nil
end

require 'open-uri'
anagram = open('http://www.puzzlers.org/pub/wordlists/unixdict.txt') do |f|
  f.read.split.group_by {|s| s.each_char.sort}
end

anagram = anagram.select{|k,list| list.size>1}.sort_by{|k,list| -k.size}

anagram.each do |k,list|
  if derangements = find_derangements(list)
    puts "Longest derangement anagram: #{derangements}"
    break
  end
end
