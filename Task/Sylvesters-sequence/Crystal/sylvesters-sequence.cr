require "big"

def sylvester
  accum = 1.to_big_i
  curr = 1.to_big_i
  Iterator.of {
    accum *= curr
    curr = accum + 1
  }
end

puts "First 10 elements:"
sylvester.first(10).each do |s|
  puts s
end

print "\nSum of the reciprocals of the first 10 elements: "
puts sylvester.first(10).sum {|s| BigRational.new(1, s) }
