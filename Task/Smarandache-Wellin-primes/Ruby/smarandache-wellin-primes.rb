require 'prime'
require 'openssl' # for it's faster 'prime?' method

Smarandache_Wellins = Struct.new(:index, :last_prime, :sw, :derived)

def derived(n)
  counter = Array.new(10){|i| [i, 0]}.to_h # counter is a Hash
  n.digits.tally(counter).values.join.to_i
end

def prime?(n) = OpenSSL::BN.new(n).prime?

ord = {1 => "1st", 2 => "2nd", 3 => "3rd"}
ord.default_proc = proc {|_h, k| k.to_s + "th"} # _ in _h means "not used"

smarandache_wellinses = Enumerator.new do |y|
  str = ""
  Prime.each.with_index(1) do |pr, i|
    str += pr.to_s
    sw = str.to_i
    y << Smarandache_Wellins.new(i, pr, sw, derived(sw))
  end
end

smarandache_wellins_primes = Enumerator.new do |y|
  smarandache_wellinses.rewind
  loop do
    s_w = smarandache_wellinses.next
    y << s_w if prime?(s_w.sw)
  end
end

sw_derived_primes = Enumerator.new do |y|
  smarandache_wellinses.rewind
  loop do
    sw  = smarandache_wellinses.next
    y << sw if prime?(sw.derived)
  end
end

n = 3
puts "The first #{n} Smarandache-Wellin primes are:"
puts smarandache_wellins_primes.first(n).map(&:sw)
puts "\nThe first #{n} Smarandache-Wellin derived primes are:"
puts sw_derived_primes.first(n).map(&:derived)

n = 7
puts "\nThe first #{n} Smarandache-Wellin primes are:"
smarandache_wellins_primes.first(n).each.with_index(1) do |swp, i|
  puts "%s: index %4d,  digits %4d,  last prime %5d " % [ord[i], swp.index, swp.sw.digits.size, swp.last_prime]
end

n = 20
puts "\nThe first #{n} Derived Smarandache-Wellin primes are:"
sw_derived_primes.first(n).each.with_index(1) do |swdp, i|
  puts "%4s: index %4d, prime %s" % [ord[i], swdp.index, swdp.derived]
end
