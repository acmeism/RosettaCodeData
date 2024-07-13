val rec gcd = fn (x, 0) => abs x | p as (_, y) => gcd (y, Int.rem p)

val lcm = fn p as (x, y) => Int.quot (abs (x * y), gcd p)
