#!/usr/bin/lasso9

define isHappy(n::integer) => {
  local(past = set)
  while(#n != 1) => {
    #n = with i in string(#n)->values sum math_pow(integer(#i), 2)
    #past->contains(#n) ? return false | #past->insert(#n)
  }
  return true
}

with x in generateSeries(1, 500)
  where isHappy(#x)
  take 8
select #x
