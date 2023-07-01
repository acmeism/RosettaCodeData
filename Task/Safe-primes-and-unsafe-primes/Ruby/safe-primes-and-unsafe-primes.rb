require "prime"
class Integer
  def safe_prime? #assumes prime
    ((self-1)/2).prime?
  end
end

def format_parts(n)
  partitions = Prime.each(n).partition(&:safe_prime?).map(&:count)
  "There are %d safes and %d unsafes below #{n}."% partitions
end

puts "First 35 safe-primes:"
p Prime.each.lazy.select(&:safe_prime?).take(35).to_a
puts format_parts(1_000_000), "\n"

puts "First 40 unsafe-primes:"
p Prime.each.lazy.reject(&:safe_prime?).take(40).to_a
puts format_parts(10_000_000)
