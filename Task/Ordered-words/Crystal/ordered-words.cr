ordered = File.open("unixdict.txt") do |f|
  f.each_line.select {|word|
    word.chars.each_cons_pair.all? {|a, b| a <= b }
  }.to_a
end
puts ordered.group_by(&.size).max[1].join(" ")
