def solve_pell(n)
  x = Integer.sqrt(n)
  y = x
  z = 1
  r = 2*x
  e1, e2 = 1, 0
  f1, f2 = 0, 1

  loop do
    y = r*z - y
    z = (n - y*y) / z
    r = (x + y) / z
    e1, e2 = e2, r*e2 + e1
    f1, f2 = f2, r*f2 + f1
    a,  b  = e2 + x*f2, f2
    break a, b if a*a - n*b*b == 1
  end
end

[61, 109, 181, 277].each {|n| puts "x*x - %3s*y*y = 1 for x = %-21s and y = %s" % [n, *solve_pell(n)]}
