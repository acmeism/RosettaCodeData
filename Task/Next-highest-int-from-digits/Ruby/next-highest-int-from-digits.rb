def next_perm(ar)
  ar = ar.dup
  rev_ar  = ar.reverse
  (a, pivot), i = rev_ar.each_cons(2).with_index(1).detect{|(e1, e2),i| e1 > e2}
  return [0] if i.nil?
  suffix  = ar[-i..]
  min_dif = suffix.map{|el|el-pivot }.reject{|el|el <= 0}.min
  ri = ar.rindex{|el| el == min_dif + pivot}
  ar[-(i+1)], ar[ri] = ar[ri], ar[-(i+1)]
  ar[-i..] = ar[-i..].reverse
  ar
end

tests = [0, 9, 12, 21, 12453, 738440, 45072010, 95322020, 9589776899767587796600]
tests.each{|t| puts "%25d -> %d" % [t, next_perm(t.to_s.chars.map(&:to_i)).join]}
