require 'prime'

def achilles?(n)
  exponents = n.prime_division.map(&:last)
  exponents.none?(1) && exponents.inject(&:gcd) == 1
end

def 𝜑(n)
  n.prime_division.inject(1){|res, (pr, exp)| res * (pr-1) * pr**(exp-1) }
end

achilleses =  (2..).lazy.select{|n| achilles?(n) }

n = 50
puts "First #{n} Achilles numbers:"
achilleses.first(n).each_slice(10){|s| puts "%9d"*s.size % s}

puts "\nFirst #{n} strong Achilles numbers:"
achilleses.select{|ach| achilles?(𝜑(ach)) }.first(n).each_slice(10){|s| puts "%9d"*s.size % s }

puts
counts = achilleses.take_while{|ach| ach < 1000000}.map{|a| a.digits.size }.tally
counts.each{|k, v| puts "#{k} digits: #{v}" }
