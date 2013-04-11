require 'openssl'
def miller_rabin_prime?(n,g)
  d = n - 1
  s = 0
  while d % 2 == 0
    d /= 2
    s += 1
  end
  g.times do
    a = 2 + rand(n-4)
    x = OpenSSL::BN::new(a.to_s).mod_exp(d,n) #x = (a**d) % n
    next if x == 1 or x == n-1
    for r in (1 .. s-1)
      x = x.mod_exp(2,n)  #x = (x**2) % n
      return false if x == 1
      break if x == n-1
    end
    return false if x != n-1
  end
  true  # probably
end

p primes = (3..1000).step(2).find_all {|i| miller_rabin_prime?(i,10)}
