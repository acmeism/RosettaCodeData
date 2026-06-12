def prime?(n) # P3 Prime Generator primality test
  return false unless (n | 1 == 3 if n < 5) || (n % 6) | 4 == 5
  sqrt = Math.sqrt(n).to_u64
  pc = typeof(n).new(5)
  while pc <= sqrt
    return false if n % pc == 0 || n % (pc + 2) == 0
    pc += 6
  end
  true
end

puts "The sum of all primes below 2 million is #{(0i64..2000000i64).select { |n| n if prime? n }.sum}."

#also

puts "The sum of all primes below 2 million is #{(0i64..2000000i64).sum(0_u64) { |n| prime?(n) ? n : 0u64 }}"

