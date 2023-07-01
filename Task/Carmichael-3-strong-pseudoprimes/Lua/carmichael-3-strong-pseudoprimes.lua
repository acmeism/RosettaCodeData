local function isprime(n)
  if n < 2 then return false end
  if n % 2 == 0 then return n==2 end
  if n % 3 == 0 then return n==3 end
  local f, limit = 5, math.sqrt(n)
  while (f <= limit) do
    if n % f == 0 then return false end; f=f+2
    if n % f == 0 then return false end; f=f+4
  end
  return true
end

local function carmichael3(p)
  local list = {}
  if not isprime(p) then return list end
  for h = 2, p-1 do
    for d = 1, h+p-1 do
      if ((h + p) * (p - 1)) % d == 0 and (-p * p) % h == (d % h) then
        local q = 1 + math.floor((p - 1) * (h + p) / d)
        if isprime(q) then
          local r = 1 + math.floor(p * q / h)
          if isprime(r) and (q * r) % (p - 1) == 1 then
            list[#list+1] = { p=p, q=q, r=r }
          end
        end
      end
    end
  end
  return list
end

local found = 0
for p = 2, 61 do
  local list = carmichael3(p)
  found = found + #list
  table.sort(list, function(a,b) return (a.p<b.p) or (a.p==b.p and a.q<b.q) or (a.p==b.p and a.q==b.q and a.r<b.r) end)
  for k,v in ipairs(list) do
    print(string.format("%.f × %.f × %.f = %.f", v.p, v.q, v.r, v.p*v.q*v.r))
  end
end
print(found.." found.")
