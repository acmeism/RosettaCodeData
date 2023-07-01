def prime?(n)                     # P3 Prime Generator primality test
  return n | 1 == 3 if n < 5      # n: 2,3|true; 0,1,4|false
  return false if n.gcd(6) != 1   # this filters out 2/3 of all integers
  sqrtN = Integer.sqrt(n)
  pc = -1                         # initial P3 prime candidates value
  until (pc += 6) > sqrtN         # is resgroup 1st prime candidate > sqrtN
    return false if n % pc == 0 || n % (pc + 2) == 0  # if n is composite
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
    ns = [0] * limit
    ns[0] = 1
    nextp = primes[0..primes.index(n)]

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
    print nsmooth(prime, 3002)[2999..-1]    # for ruby >= 2.6: (..)[2999..]
    puts
end
puts
gen_primes(503, 521).each do |prime|
    print "The 30,000 to 30,019 #{prime}-smooth numbers are: \n"
    print nsmooth(prime, 30019)[29999..-1]  # for ruby >= 2.6: (..)[29999..]
    puts
end
