def modinv(a0, m0)
  return 1 if m0 == 1
  a, m = a0, m0
  x0, inv = 0, 1
  while a > 1
    inv -= (a // m) * x0
    a, m = m, a % m
    x0, inv = inv, x0
  end
  inv += m0 if inv < 0
  inv
end
