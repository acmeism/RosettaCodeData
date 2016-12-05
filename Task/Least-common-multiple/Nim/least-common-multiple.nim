proc gcd(u, v): auto =
  var
    t = 0
    u = u
    v = v
  while v != 0:
    t = u
    u = v
    v = t %% v
  abs(u)

proc lcm(a, b): auto = abs(a * b) div gcd(a, b)

echo lcm(12, 18)
echo lcm(-6, 14)
