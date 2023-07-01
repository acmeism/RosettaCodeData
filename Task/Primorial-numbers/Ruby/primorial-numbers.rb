require 'prime'

def primorial_number(n)
  pgen = Prime.each
  (1..n).inject(1){|p,_| p*pgen.next}
end

puts "First ten primorials: #{(0..9).map{|n| primorial_number(n)}}"

(1..5).each do |n|
  puts "primorial(10**#{n}) has #{primorial_number(10**n).to_s.size} digits"
end
