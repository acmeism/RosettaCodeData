function SubGen(seed)
  local n, r, s = 54, {}, { [0]=seed, 1 }
  for n = 2,54 do s[n] = (s[n-2] - s[n-1]) % 1e9 end
  for n = 0,54 do r[n] = s[(34*(n+1))%55] end
  local next = function()
    n = (n+1) % 55
    r[n] = (r[(n-55)%55] - r[(n-24)%55]) % 1e9
    return r[n]
  end
  for n = 55,219 do next() end
  return next
end
subgen = SubGen(292929)
for n = 220,229 do print(n,subgen()) end
