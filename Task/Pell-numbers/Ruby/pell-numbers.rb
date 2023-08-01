require 'openssl'
def prime?(n) = OpenSSL::BN.new(n).prime?

pell = Enumerator.new do |y|
  pe = [0,1]
  loop{y << pe[0]; pe << pe[1]*2 + pe.shift}
end

pell_lucas = Enumerator.new do |y|
  pe = [2,2]
  loop{y << pe[0]; pe << pe[1]*2 + pe.shift}
end

n = 20
puts "First #{n} Pell numbers: #{pell.first(n).to_a.inspect}"
puts "\nFirst #{n} Pell-Lucas numbers: #{pell_lucas.first(n).to_a.inspect}"

n = 15
sqrt2 = pell.each_cons(2).lazy.map{|p1,p2|  Rational(p1+p2, p2)}.take(n).to_a
puts "\nThe first #{n} rational approximations of √2 (#{Math.sqrt(2)}) are:"
sqrt2.each{|n| puts "%-16s ≈ %-18s\n"% [n, n.to_f]}

puts "\nThe first #{n} Pell primes with index are:"
primes = pell.with_index.lazy.select{|n, i|prime?(i) && prime?(n)}.first(n)
primes.each {|prime, i| puts "#{i.to_s.ljust(3)} #{prime}"}

puts "\nThe first #{n} NSW numbers:"
puts  pell.first(2*n).each_slice(2).map(&:sum).join(", ")

puts "\nFirst #{n} near isosceles right triangles:"
sum = 1
pell.take(n*2+2).each_slice(2) do |p1,p2|
  next if p1 == 0
  sum += p1
  puts "#{sum}, #{sum+1}, #{p2}"
  sum += p2
end
