sumhappy(n) = sum(x->x^2, digits(n))

function ishappy(x, mem = Int[])
  x == 1 ?   true :
  x in mem ? false :
  ishappy(sumhappy(x), [mem ; x])
end

nexthappy(x) = ishappy(x+1) ? x+1 : nexthappy(x+1)
happy(n) = accumulate((a, b) -> nexthappy(a), 1:n)
