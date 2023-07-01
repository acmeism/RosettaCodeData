divert(-1)

define(`gcd',
  `ifelse(eval(`0 <= (' $1 `)'),`0',`gcd(eval(`-(' $1 `)'),eval(`(' $2 `)'))',
          eval(`0 <= (' $2 `)'),`0',`gcd(eval(`(' $1 `)'),eval(`-(' $2 `)'))',
          eval(`(' $1 `) == 0'),`0',`gcd(eval(`(' $2 `) % (' $1 `)'),eval(`(' $1 `)'))',
          eval(`(' $2 `)'))')

define(`lcm',
  `ifelse(eval(`0 <= (' $1 `)'),`0',`lcm(eval(`-(' $1 `)'),eval(`(' $2 `)'))',
          eval(`0 <= (' $2 `)'),`0',`lcm(eval(`(' $1 `)'),eval(`-(' $2 `)'))',
          eval(`(' $1 `) == 0'),`0',`eval(`(' $1 `) * (' $2 `) /' gcd(eval(`(' $1 `)'),eval(`(' $2 `)')))')')

divert`'dnl
dnl
lcm(-6, 14) = 42
lcm(2, 0) = 0
lcm(12, 18) = 36
lcm(12, 22) = 132
lcm(7, 31) = 217
