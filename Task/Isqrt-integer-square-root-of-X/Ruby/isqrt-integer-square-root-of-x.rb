module Commatize
  refine Integer do
    def commatize
      self.to_s.gsub( /(\d)(?=\d{3}+(?:\.|$))(\d{3}\..*)?/, "\\1,\\2")
    end
  end
end

using Commatize
def isqrt(x)
    q, r = 1, 0
    while (q <= x) do q <<= 2 end
    while (q > 1) do
        q >>= 2; t = x-r-q; r >>= 1
        if (t >= 0) then x, r = t, r+q end
    end
    r
end

puts (0..65).map{|n| isqrt(n) }.join(" ")

1.step(73, 2) do |n|
  print "#{n}:\t"
  puts isqrt(7**n).commatize
end
