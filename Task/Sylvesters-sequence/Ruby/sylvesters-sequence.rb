def sylvester(n) = (1..n).reduce(2){|a| a*a - a + 1 }

(0..9).each {|n| puts "#{n}: #{sylvester n}"  }
puts "
Sum of reciprocals of first 10 terms:
#{(0..9).sum{|n| 1.0r / sylvester(n)}.to_f }"
