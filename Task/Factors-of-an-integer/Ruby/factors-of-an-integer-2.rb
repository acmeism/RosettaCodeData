class Integer
  def factors
    1.upto(Integer.sqrt(self)).select {|i| (self % i).zero?}.inject([]) do |f, i|
      f << self/i unless i == self/i
      f << i
    end.sort
  end
end
[45, 53, 64].each {|n| puts "#{n} : #{n.factors}"}
