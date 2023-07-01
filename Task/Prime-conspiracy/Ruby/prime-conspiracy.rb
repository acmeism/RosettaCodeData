require "prime"

def prime_conspiracy(m)
  conspiracy = Hash.new(0)
  Prime.take(m).map{|n| n%10}.each_cons(2){|a,b| conspiracy[[a,b]] += 1}
  puts "#{m} first primes. Transitions prime % 10 → next-prime % 10."
  conspiracy.sort.each do |(a,b),v|
    puts "%d → %d count:%10d frequency:%7.4f %" % [a, b, v, 100.0*v/m]
  end
end

prime_conspiracy(1_000_000)
