require 'prime'

batas = 64_000    # limit number
start = Time.now  # time of starting
lp_array = []     # array of long-prime numbers

def find_period(n)
  r, period = 1, 0
  (1...n).each {r = (10 * r) % n}
  rr = r
  loop do
    r = (10 * r) % n
    period += 1
    break if r == rr
  end
  return period
end

Prime.each(batas).each do |prime|
  lp_array.push(prime) if find_period(prime) == prime-1 && prime != 2
end

[500, 1000, 2000, 4000, 8000, 16000, 32000, 64000].each do |s|
  if s == 500
    puts "\nAll long primes up to  #{s} are: #{lp_array.count {|x| x < s}}. They are:"
    lp_array.each {|x| print x, " " if x < s}
  else
    print "\nAll long primes up to #{s} are: #{lp_array.count {|x| x < s}}"
  end
end

puts "\n\nTime: #{Time.now - start}"
