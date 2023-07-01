class Integer

  def popcount
    digits(2).count(1)     #pre Ruby 2.4: self.to_s(2).count("1")
  end

  def evil?
    self >= 0 && popcount.even?
  end

end

puts "Powers of 3:",  (0...30).map{|n| (3**n).popcount}.join(' ')
puts "Evil:"  , 0.step.lazy.select(&:evil?).first(30).join(' ')
puts "Odious:", 0.step.lazy.reject(&:evil?).first(30).join(' ')
