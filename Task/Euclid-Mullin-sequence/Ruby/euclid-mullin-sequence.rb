def pollard_rho(n)
  x, y, d = 2, 2, 1
  g = proc{|x|(x*x+1) % n}
  while d == 1 do
    x = g[x]
    y = g[g[y]]
    d = (x-y).abs.gcd(n)
  end
  return d if d == n
  [d, n/d].compact.min
end

ar = [2]
ar << pollard_rho(ar.inject(&:*)+1) until ar.size >= 16
puts ar.join(", ")
