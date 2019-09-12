require 'prime'
# 75.prime_division # Returns the factorization.75 divides by 3 once and by 5 twice => [[3, 1], [5, 2]]

class Integer
  def semi_prime?
    prime_division.sum(&:last) == 2
  end
end

p 1679.semi_prime? # true
p ( 1..100 ).select( &:semi_prime? )
# [4, 6, 9, 10, 14, 15, 21, 22, 25, 26, 33, 34, 35, 38, 39, 46, 49, 51, 55, 57, 58, 62, 65, 69, 74, 77, 82, 85, 86, 87, 91, 93, 94, 95]
