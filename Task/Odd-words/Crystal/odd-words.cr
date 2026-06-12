words = File.open("unixdict.txt") do |f|
  f.each_line.select { |w| w.size >= 5 }.to_set
end

oddw = words.select { |w| w.size >= 9 }.compact_map { |outer|
  inner = outer.chars.each_step(2).join
  if words.includes? inner
    { outer, inner }
  end
}.sort_by { |o, i| o }

pp oddw
