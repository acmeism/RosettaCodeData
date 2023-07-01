# Sequence of primorial primes

require 'prime' # for creating prime_array
require 'openssl' # for using fast Miller–Rabin primality test (just need 10.14 seconds to complete)

i, urutan, primorial_number = 1, 1, OpenSSL::BN.new(1)
start = Time.now
prime_array = Prime.first (500)

until urutan > 20
  primorial_number *= prime_array[i-1]
  if (primorial_number - 1).prime_fasttest? || (primorial_number + 1).prime_fasttest?
    puts "#{Time.now - start} \tPrimorial prime #{urutan}: #{i}"
    urutan += 1
  end
  i += 1
end
