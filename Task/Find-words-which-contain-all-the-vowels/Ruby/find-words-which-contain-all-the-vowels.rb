File.open("unixdict.txt").each(chomp: true) do |word|
  puts word if word.size > 10 && word.chars.tally.values_at('a','e','i','o','u').all?(1)
end
