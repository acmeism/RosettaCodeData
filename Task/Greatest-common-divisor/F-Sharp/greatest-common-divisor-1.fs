let rec gcd a b =
  if b = 0
    then abs a
  else gcd b (a % b)

>gcd 400 600
val it : int = 200
