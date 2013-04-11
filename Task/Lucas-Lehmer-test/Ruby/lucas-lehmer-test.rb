def is_prime ( p )
  if p == 2
    return true
  elsif p <= 1 || p % 2 == 0
    return false
  else
    (3 .. Math.sqrt(p)).step(2) do |i|
      if p % i == 0
        return false
      end
    end
    return true
  end
end

def is_mersenne_prime ( p )
  if p == 2
    return true
  else
    m_p = ( 1 << p ) - 1
    s = 4
    (p-2).times do
      s = (s ** 2 - 2) % m_p
    end
    return s == 0
  end
end

precision = 20000   # maximum requested number of decimal places of 2 ** MP-1 #
long_bits_width = precision / Math.log(2) * Math.log(10)
upb_prime = (long_bits_width - 1).to_i / 2    # no unsigned #
upb_count = 45      # find 45 mprimes if int was given enough bits #

puts " Finding Mersenne primes in M[2..%d]:"%upb_prime

count = 0
for p in 2..upb_prime
  if is_prime(p) && is_mersenne_prime(p)
    print "M%d "%p
    count += 1
  end
  if count >= upb_count
    break
  end
end
puts
