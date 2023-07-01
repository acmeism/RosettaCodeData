class String
  def sum_digits(base : Int) : Int32
  	self.chars.reduce(0) { |acc, c|
  		value = c.to_i(base)
  		acc += value
  	}
  end
end

puts("1".sum_digits 10)
puts("1234".sum_digits 10)
puts("fe".sum_digits 16)
puts("f0e".sum_digits 16)
