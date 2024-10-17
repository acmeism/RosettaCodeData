def roll_stat
  dices = Array(Int32).new(4) { rand(1..6) }
  dices.sum - dices.min
end

def roll_character
  loop do
    stats = Array(Int32).new(6) { roll_stat }
    return stats if stats.sum >= 75 && stats.count(&.>=(15)) >= 2
  end
end

10.times do
  stats = roll_character
  puts "stats: #{stats}, sum is #{stats.sum}"
end
