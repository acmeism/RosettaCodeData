def w_prime?(i)
  return false if i < 2
  ((1..i-1).inject(&:*) + 1) % i == 0
end

p (1..100).select{|n| w_prime?(n) }
