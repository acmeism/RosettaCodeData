require 'prime'

def concat(n)
  n.prime_division.map{|pr, exp| pr.to_s * exp }.join.to_i
end

def hp(n)
  res = [n]
  res << n = concat(n) until n.prime?
  res
end

def hp_to_s(ar)
  return "HP#{ar[0]}(1) = #{ar[0]}" if ar.size == 1
  ar[0..-2].map.with_index(1){|n, i| "HP#{n}(#{(ar.size-i)}) = "}.join + ar.last.to_s
end

(2..20).each {|n| puts hp_to_s(hp(n)) }
