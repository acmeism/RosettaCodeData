def dif(s)
  s.each_cons(2).collect { |x, y| y - x }
end

def difn(s, n)
  n.times.inject(s) { |s, | dif(s) }
end
