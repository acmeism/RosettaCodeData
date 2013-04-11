class Integer
  def factors()
    1.upto(Math.sqrt(self)).select {|i| (self % i).zero?}.inject([]) do |f, i|
      f << i
      f << self/i unless i == self/i
      f
    end.sort
  end
end
[45, 53, 64].each {|n| p n.factors}
