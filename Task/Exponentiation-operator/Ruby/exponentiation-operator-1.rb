class Numeric
  def pow(m)
    raise TypeError, "exponent must be an integer: #{m}" unless m.is_a? Integer
    puts "pow!!"
    Array.new(m, self).reduce(1, :*)
  end
end

p 5.pow(3)
p 5.5.pow(3)
p 5.pow(3.1)
