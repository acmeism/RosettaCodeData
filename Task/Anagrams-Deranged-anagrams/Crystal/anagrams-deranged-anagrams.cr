def deranged? (a, b)
  a.chars.zip(b.chars).all? {|char_a, char_b| char_a != char_b}
end

def find_derangements (list)
  list.each_combination(2) {|(a, b)| return a, b  if deranged?(a, b)}
  nil
end

anagram = File.read_lines("unixdict.txt").group_by {|s| s.chars.sort}

anagram = anagram.select {|k,list| list.size>1}.to_a.sort_by! {|k, list| -k.size}

anagram.each do |k, list|
  if derangements = find_derangements(list)
    puts "Longest derangement anagram: #{derangements}"
    break
  end
end
