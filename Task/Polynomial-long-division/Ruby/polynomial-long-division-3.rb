def tcl_polynomial_division(f, g)
  if g.length == 0 or (g.length == 1 and g[0] == 0)
    raise ArgumentError, "denominator is zero"
  end
  return [[0], f] if f.length < g.length

  q = []
  n, d = f.dup, g
  while n.length >= d.length
    q << Float(n[0]) / d[0]
    n[0, d.length].zip(d).each_with_index do |pair, i|
      n[i] = Float(pair[0]) - q[-1] * pair[1]
    end
    n.shift
  end
  q = [0] if q.empty?
  n = [0] if n.empty?
  [q, n]
end

f = [1, -12, 0, -42]
g = [1, -3]
q, r = polynomial_division(f, g)
p [f, g, q, r]
# => [[1, -12, 0, -42], [1, -3], [1, -9, -27], [-123]]

g = [1, 1, -3]
q, r = polynomial_division(f, g)
p [f, g, q, r]
# => [[1, -12, 0, -42], [1, 1, -3], [1, -13], [16, -81]]
