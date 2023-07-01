function T(t) return setmetatable(t, {__index=table}) end
table.range = function(t,n) local s=T{} for i=1,n do s[i]=i end return s end
table.map = function(t,f) local s=T{} for i=1,#t do s[i]=f(t[i]) end return s end
table.batch = function(t,n,f) for i=1,#t,n do local s=T{} for j=1,n do s[j]=t[i+j-1] end f(s) end return t end

function isprime(n)
  if n < 2 then return false end
  if n % 2 == 0 then return n==2 end
  if n % 3 == 0 then return n==3 end
  for f = 5, n^0.5, 6 do
    if n%f==0 or n%(f+2)==0 then return false end
  end
  return true
end

function goldbach(n)
  local count = 0
  for i = 1, n/2 do
    if isprime(i) and isprime(n-i) then
      count = count + 1
    end
  end
  return count
end

print("The first 100 G numbers:")
g = T{}:range(100):map(function(n) return goldbach(2+n*2) end)
g:map(function(n) return string.format("%2d ",n) end):batch(10,function(t) print(t:concat()) end)
print("G(1000000) = "..goldbach(1000000))
