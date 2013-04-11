def play(low, high, turns = 1)
  num = low + (high - low) / 2
  print "guessing #{num}\t"
  case is_it?(num)
  when 1
    puts "too high"
    play(low, num, turns + 1)
  when -1
    puts "too low"
    play(num, high, turns + 1)
  else
    puts "found the number in #{turns} turns."
  end
end

def is_it?(num)
  num <=> $number
end

low = 1
high = 100
$number = low + rand(high-low)

puts "guess a number between #{low} and #{high}"
play(low, high)
