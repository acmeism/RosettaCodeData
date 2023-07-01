require 'prime'

strong_gen = Enumerator.new{|y| Prime.each_cons(3){|a,b,c|y << b if a+c-b<b} }
weak_gen   = Enumerator.new{|y| Prime.each_cons(3){|a,b,c|y << b if a+c-b>b} }

puts "First 36 strong primes:"
puts strong_gen.take(36).join(" "), "\n"
puts "First 37 weak primes:"
puts weak_gen.take(37).join(" "), "\n"

[1_000_000, 10_000_000].each do |limit|
  strongs, weaks = 0, 0
  Prime.each_cons(3) do |a,b,c|
    strongs += 1 if b > a+c-b
    weaks += 1 if b < a+c-b
    break if c > limit
  end
  puts "#{strongs} strong primes and #{weaks} weak primes below #{limit}."
end
