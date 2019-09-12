--more pedantic version, returns 0 for non-integer n
function pfibs(n)
  if n ~= math.floor(n) then return 0
  elseif n < 0 then return pfibs(n + 2) - pfibs(n + 1)
  elseif n < 2 then return n
  else return pfibs(n - 1) + pfibs(n - 2)
  end
end
