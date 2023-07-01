require 'prime'

class Integer
  def sphenic? = prime_division.map(&:last) == [1, 1, 1]
end

sphenics = (1..).lazy.select(&:sphenic?)

n = 1000
puts "Sphenic numbers less than #{n}:"
p sphenics.take_while{|s| s < n}.to_a

n = 10_000
puts "\nSphenic triplets less than #{n}:"
sps = sphenics.take_while{|s| s < n}.to_a
sps.each_cons(3).select{|a, b, c| a + 2 == c}.each{|ar| p ar}

n = 1_000_000
sphenics_below10E6 = sphenics.take_while{|s| s < n}.to_a
puts "\nThere are #{sphenics_below10E6.size} sphenic numbers below #{n}."
target = sphenics_below10E6[200_000-1]
puts "\nThe 200000th sphenic number is #{target} with factors #{target.prime_division.map(&:first)}."
triplets = sphenics_below10E6.each_cons(3).select{|a,b,c|a+2 == c}
puts "\nThe 5000th sphenic triplet is #{triplets[4999]}."
