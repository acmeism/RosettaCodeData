def vdc(n, base=2)
  str = n.to_s(base).reverse
  str.to_i(base).quo(base ** str.length)
end
