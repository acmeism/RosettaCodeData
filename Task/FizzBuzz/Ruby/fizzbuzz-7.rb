1.upto(100) { |i| puts "#{[:Fizz][i%3]}#{[:Buzz][i%5]}"[/.+/] || i }
