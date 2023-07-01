sumhappy(n) = sum(x->x^2, digits(n))

function ishappy(x, mem = [])
  x == 1?   true :
  x in mem? false :
  ishappy(sumhappy(x),[mem ; x])
end

nexthappy (x) = ishappy(x+1) ? x+1 : nexthappy(x+1)

happy(n) = [z = 1 ; [z = nexthappy(z) for i = 1:n-1]]
