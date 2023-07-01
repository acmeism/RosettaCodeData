fun gcd a 0 = a
  | gcd a b = gcd b (a mod b)
