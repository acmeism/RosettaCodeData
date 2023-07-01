def play(low, high, turns=1)
  num = (low + high) / 2
  print "guessing #{num}\t"
  case is_it?(num)
  when 1
    puts "too high"
    play(low, num - 1, turns + 1)
  when -1
    puts "too low"
    play(num + 1, high, turns + 1)
  else
    puts "found the number in #{turns} turns."
  end
end

def is_it?(num)
  num <=> $number
end

low, high = 1, 100
$number = rand(low .. high)

puts "guess a number between #{low} and #{high}"
play(low, high)
