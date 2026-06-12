def root(a,b)
  return b if b<2
  a1, c = a-1, 1
  f = -> x {(a1*x+b/(x**a1))/a}  # a lambda with argument x
  d = f[c]
  e = f[d]
  c, d, e = d, e, f[e] until [d,e].include?(c)
  [d,e].min
end

puts "First 2,001 digits of the square root of two:"
puts root(2, 2*100**2000)
