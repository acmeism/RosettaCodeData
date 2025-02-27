File.open("les_miserables.txt") do |f|
  pp f.each_char.select(&.letter?).tally.to_a.sort_by {|k,v| -v}
end
