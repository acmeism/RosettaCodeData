#!/usr/bin/lasso9

define isPerfect(n::integer) => {
  #n < 2 ? return false
  return #n == (
    with i in generateSeries(1, math_floor(math_sqrt(#n)) + 1)
      where #n % #i == 0
      let q = #n / #i
    sum (#q > #i ? (#i == 1 ? 1 | #q + #i) | 0)
  )
}

with x in generateSeries(1, 10000)
  where isPerfect(#x)
select #x
