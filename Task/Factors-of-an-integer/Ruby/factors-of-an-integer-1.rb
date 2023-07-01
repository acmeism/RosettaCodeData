class Integer
  def factors() (1..self).select { |n| (self % n).zero? } end
end
p 45.factors
