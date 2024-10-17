require "big"

def sumMul(n, f)
  n1 = (n.to_big_i - 1) // f  # number of multiples of f < n
  f * n1 * (n1 + 1) // 2      # f * (sum of number of multiples)
end

def sum35(n)
  sumMul(n, 3) + sumMul(n, 5) - sumMul(n, 15)
end

(1..20).each do |e| limit = 10.to_big_i ** e
  puts "%2d:%22d %s" % [e, limit, sum35(limit)]
end
