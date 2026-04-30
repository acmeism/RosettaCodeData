isograms = File.open("unixdict.txt") do |f|
  f.each_line.compact_map {|word|
    counts = word.chars.tally.values
    if counts.all? {|cnt| cnt == counts[0] }
      { word, counts[0] }
    end
  }.to_a
end

puts "n-isograms (n > 1):"
puts isograms.select {|_, n| n > 1}
      .sort_by! {|w, n| {-n, -w.size, w} }
      .map {|w, _| w }
      .join(" ")
puts
puts "Heterograms:"
puts isograms.select {|w, n| n == 1 && w.size > 10 }
      .sort_by! {|w, _| { -w.size, w } }
      .map {|w, _| w }
      .join(" ")
