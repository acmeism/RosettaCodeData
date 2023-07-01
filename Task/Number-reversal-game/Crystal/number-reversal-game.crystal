SIZE = 9
ordered = (1..SIZE).to_a
shuffled = (1..SIZE).to_a

while shuffled == ordered
  shuffled.shuffle!
end

score = 0
until shuffled == ordered
  print "#{shuffled} Enter items to reverse: "

  next unless guess = gets
  next unless num = guess.to_i?
  next if num < 2 || num > SIZE

  shuffled[0, num] = shuffled[0, num].reverse
  score += 1
end

puts "#{shuffled} Your score: #{score}"
