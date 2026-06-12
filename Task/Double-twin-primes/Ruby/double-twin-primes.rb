require 'prime'

res = Prime.each(1000).each_cons(4).select do |p1, p2, p3, p4|
  p1+2 == p2 && p2+4 == p3 && p3+2 == p4
end

res.each{|slice| puts slice.join(", ")}
