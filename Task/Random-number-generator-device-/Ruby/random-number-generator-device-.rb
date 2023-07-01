require 'securerandom'
SecureRandom.random_number(1 << 32)

#or specifying SecureRandom as the desired RNG:
p (1..10).to_a.sample(3, random: SecureRandom) # =>[1, 4, 5]
