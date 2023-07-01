local wrap, yield = coroutine.wrap, coroutine.yield
local function perm(n)
    local r = {}
    for i=1,n do r[i]=i end
    local sign = 1
  return wrap(function()
    local function swap(m)
      if m==0 then
        sign = -sign, yield(sign,r)
      else
        for i=m,1,-1 do
          r[i],r[m]=r[m],r[i]
          swap(m-1)
          r[i],r[m]=r[m],r[i]
        end
      end
    end
    swap(n)
  end)
end
for sign,r in perm(3) do print(sign,table.unpack(r))end
