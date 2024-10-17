require "big"

def prime?(n) # P3 Prime Generator primality test
  return false unless (n | 1 == 3 if n < 5) || (n % 6) | 4 == 5
  sqrt_n = Math.isqrt(n)  # For Crystal < 1.2.0 use Math.sqrt(n).to_i
  pc = typeof(n).new(5)
  while pc <= sqrt_n
    return false if n % pc == 0 || n % (pc + 2) == 0
    pc += 6
  end
  true
end

def gen_primes(a, b)
    (a..b).select { |pc| pc if prime? pc }
end

def nsmooth(n, limit)
    raise "Exception(n or limit)" if n < 2 || n > 521 || limit < 1
    raise "Exception(must be a prime number: n)" unless prime? n

    primes = gen_primes(2, n)
    ns = [0.to_big_i] * limit
    ns[0] = 1.to_big_i
    nextp = primes[0..primes.index(n)].map { |prm| prm.to_big_i }

    indices = [0] * nextp.size
    (1...limit).each do |m|
        ns[m] = nextp.min
        (0...indices.size).each do |i|
            if ns[m] == nextp[i]
                indices[i] += 1
                nextp[i] = primes[i] * ns[indices[i]]
            end
        end
    end
    ns
end

gen_primes(2, 29).each do |prime|
    print "The first 25 #{prime}-smooth numbers are: \n"
    print nsmooth(prime, 25)
    puts
end
puts
gen_primes(3, 29).each do |prime|
    print "The 3000 to 3202 #{prime}-smooth numbers are: "
    print nsmooth(prime, 3002)[2999..]
    puts
end
puts
gen_primes(503, 521).each do |prime|
    print "The 30,000 to 30,019 #{prime}-smooth numbers are: \n"
    print nsmooth(prime, 30019)[29999..]
    puts
end
