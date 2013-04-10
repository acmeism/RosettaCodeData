require 'open-uri'
anagram = nil
open('http://www.puzzlers.org/pub/wordlists/unixdict.txt') do |f|
  anagram = f.read.split.group_by {|s| s.each_char.sort}
end

def deranged?(a, b)
  a.chars.zip(b.chars).all? {|char_a, char_b| char_a != char_b}
end

def remove_non_derangements(val)
  list = val.dup
  for i in 0 ... list.length
    j = i + 1
    while j < list.length
      if deranged?(list[i], list[j])
        j += 1
      else
        list.delete_at(j)
      end
    end
  end
  list
end

max_word_length = anagram.each_value .
                          select {|list| list.length > 1} .
                          map {|list| list[0].length} .
                          max

derangements = []

until derangements.length > 1
  puts "looking for deranged anagrams with word length #{max_word_length}"

  anagram.each_value .
          select {|list| list.length > 1 and list[0].length == max_word_length} .
          each do |list|
            derangements = remove_non_derangements(list)
            break if derangements.length > 1
          end

  max_word_length -= 1
end

puts "derangement with longest word length: #{derangements}"
