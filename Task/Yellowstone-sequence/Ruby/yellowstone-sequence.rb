def yellow(n)
  a = [1, 2, 3]
  b = { 1 => true, 2 => true, 3 => true }
  i = 4
  while n > a.length
    if !b[i] && i.gcd(a[-1]) == 1 && i.gcd(a[-2]) > 1
      a << i
      b[i] = true
      i = 4
    end
    i += 1
  end
  a
end

p yellow(30)
