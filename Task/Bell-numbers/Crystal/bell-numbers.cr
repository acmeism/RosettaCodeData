require "big"

row = [1.to_big_i]

(1..50).each do |i|
  puts "%2d: %s" % { i, i <= 10 ? row : row.first } if 1 <= i <= 15 || i == 50
  next_row = [row.last]
  row.each do |n|
    next_row << n + next_row.last
  end
  row = next_row
end
