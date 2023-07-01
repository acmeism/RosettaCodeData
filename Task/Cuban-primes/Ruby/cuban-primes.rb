require "openssl"

RE = /(\d)(?=(\d\d\d)+(?!\d))/ # Activesupport uses this for commatizing
cuban_primes = Enumerator.new do |y|
  (1..).each do |n|
    cand = 3*n*(n+1) + 1
    y << cand if OpenSSL::BN.new(cand).prime?
  end
end

def commatize(num)
  num.to_s.gsub(RE, "\\1,")
end

cbs = cuban_primes.take(200)
formatted = cbs.map{|cb| commatize(cb).rjust(10) }
puts formatted.each_slice(10).map(&:join)

t0 = Time.now
puts "
100_000th cuban prime is #{commatize( cuban_primes.take(100_000).last)}
which took #{(Time.now-t0).round} seconds to calculate."
