function nthroot (x, n)
  local r = 1
  for i = 1, 16 do
    r = (((n - 1) * r) + x / (r ^ (n - 1))) / n
  end
  return r
end

local i, count, sq, cbrt = 0, 0
while count < 30 do
  i = i + 1
  sq = i * i
  -- The next line should say nthroot(sq, 3), right? But this works. Maths, eh?
  cbrt = nthroot(i, 3)
  if cbrt == math.floor(cbrt) then
    print(sq .. " is square and cube")
  else
    print(sq)
    count = count + 1
  end
end
