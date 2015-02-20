def polynomial_division(f, g)
  if g.length == 0 or (g.length == 1 and g[0] == 0)
    raise ArgumentError, "denominator is zero"
  end
  return [[0], f] if f.length < g.length

  q, n = [], f.dup
  while n.length >= g.length
    q << Float(n[0]) / g[0]
    n[0, g.length].zip(g).each_with_index do |pair, i|
      n[i] = pair[0] - q[-1] * pair[1]
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
puts "#{f} / #{g} => #{q} remainder #{r}"
# => [1, -12, 0, -42] / [1, -3] => [1.0, -9.0, -27.0] remainder [-123.0]

g = [1, 1, -3]
q, r = polynomial_division(f, g)
puts "#{f} / #{g} => #{q} remainder #{r}"
# => [1, -12, 0, -42] / [1, 1, -3] => [1.0, -13.0] remainder [16.0, -81.0]
