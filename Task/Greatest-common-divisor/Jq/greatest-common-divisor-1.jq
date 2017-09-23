def recursive_gcd(a; b):
  if b == 0 then a
  else recursive_gcd(b; a % b)
  end ;
