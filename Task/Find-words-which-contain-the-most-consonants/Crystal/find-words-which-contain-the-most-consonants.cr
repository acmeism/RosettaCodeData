list = File.open("unixdict.txt") do |f|
  f.each_line.compact_map { |word|
    if word.size > 10
      consonants = word.gsub(/[aeiou]|y$|y(?=[^aeiou])/, "").chars
      if consonants.to_set.size == consonants.size
        { word, consonants.size }
      end
    end
  }.to_a
end

puts "First 5 by number of consonants"
list.sort_by {|w, s| { -s, w } }.first(5).each do |word, nconsonants|
  puts "  #{nconsonants} #{word}"
end

puts "\nFirst 5 by consonant ratio"
list.map {|w, s| { w, s / w.size } }.sort_by {|w, r| { -r, w } }.first(5).each do |word, cratio|
  printf "  %5.3f %s\n", cratio, word
end
