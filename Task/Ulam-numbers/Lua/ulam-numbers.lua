function ulam(n)
  local ulams, nways, i = { 1,2 }, { 0,0,1 }, 3
  repeat
    if nways[i] == 1 then
      for j = 1, #ulams do
        local sum = i + ulams[j]
        nways[sum] = (nways[sum] or 0) + 1
      end
      ulams[#ulams+1] = i
    end
    i = i + 1
  until #ulams == n
  return ulams[#ulams]
end

for _,n in ipairs({10,100,1000,10000,100000}) do
  local s, u, e = os.clock(), ulam(n), os.clock()
  print(string.format("%dth is %d (%f seconds elapsed)", n, u, e-s))
end
