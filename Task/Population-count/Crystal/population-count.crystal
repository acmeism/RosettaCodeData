struct Int
  def evil?
    self >= 0 && popcount.even?
  end
end

puts "Powers of 3:", (0...30).map{|n| (3u64 ** n).popcount}.join(' ') # can also use &** (to prevent arithmetic overflow)
puts "Evil:"  , 0.step.select(&.evil?).first(30).join(' ')
puts "Odious:", 0.step.reject(&.evil?).first(30).join(' ')
