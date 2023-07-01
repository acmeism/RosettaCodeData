proc gcd(u, v: int): auto =
  var
    u = u
    v = v
  while v != 0:
    u = u %% v
    swap u, v
  abs(u)

proc lcm(a, b: int): auto = abs(a * b) div gcd(a, b)

echo lcm(12, 18)
echo lcm(-6, 14)
