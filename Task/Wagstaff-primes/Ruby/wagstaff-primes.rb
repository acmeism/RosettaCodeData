require 'prime'
require 'gmp'

wagstaffs = Enumerator.new do |y|
  odd_primes = Prime.each
  odd_primes.next #skip 2
  loop do
    p = odd_primes.next
    candidate = (2 ** p + 1)/3
    y << [p, candidate] unless GMP::Z.new(candidate).probab_prime?.zero?
  end
end

10.times{puts "%5d - %s" % wagstaffs.next}
14.times{puts "%5d" % wagstaffs.next.first}
