let rec gcd a = function
  | 0 -> a
  | b -> gcd b (a mod b)
