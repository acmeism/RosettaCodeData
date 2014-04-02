r = (1..100)
secret = rand(r)
turns = 0

puts "Guess a number between #{r.min} and #{r.max}"
r.bsearch do |guess|                # bsearch works on ranges
  print "Guessing #{guess} \t"
  turns += 1
  low_high = secret <=> guess       # -1, 0, or 1
  puts ["found the number in #{turns} turns", "too low", "too high"][low_high]
  low_high
end
