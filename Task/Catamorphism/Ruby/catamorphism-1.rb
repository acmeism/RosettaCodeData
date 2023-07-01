# sum:
p (1..10).inject(:+)
# smallest number divisible by all numbers from 1 to 20:
p (1..20).inject(:lcm) #lcm: lowest common multiple
