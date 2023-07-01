function fact(n, acc)
  acc = acc or 1
  if n == 0 then
    return acc
  end
  return fact(n-1, n*acc)
end
