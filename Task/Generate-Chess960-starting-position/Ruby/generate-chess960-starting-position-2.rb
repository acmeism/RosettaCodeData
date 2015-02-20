row = [:♖, :♔, :♖]
[:♕, :♘, :♘].each{|piece| row.insert(rand(row.size+1), piece)}
[[0, 2, 4, 6].sample, [1, 3, 5, 7].sample].sort.each{|pos| row.insert(pos, :♗)}

puts row
