struct Number
  def to_mixed_radix (*radices)
    result = Array(self).new(radices.size, 0)
    n = self
    (0...radices.size).reverse_each do |i|
      break if n == 0
      divisor = radices[i]
      if divisor == 0
        result[i] = n
        break
      end
      result[i] = n % divisor
      n //= divisor
    end
    result
  end
end

def to_compound (num, radices, units)
  num.to_mixed_radix(*radices).zip(units).compact_map {|n, u|
    if n != 0
      "#{n} #{u}"
    end
  }.join(", ")
end

def secs_to_compound (secs)
  to_compound secs, {0, 7, 24, 60, 60}, ["wk", "d", "hr", "min", "sec"]
end

puts "The task:"
[7259, 86400, 6000000].each do |n|
  printf "%7s sec = %s\n", n, secs_to_compound(n)
end

puts "\n(nobody asked for this):"
def inches_to_compound (inches)
  to_compound inches, {0, 3, 8, 10, 22, 3, 12}, ["lea", "mi", "fur", "ch", "yd", "ft", "in"]
end

[7259, 86400, 6000000].each do |n|
  printf "%7s in = %s\n", n, inches_to_compound(n)
end
