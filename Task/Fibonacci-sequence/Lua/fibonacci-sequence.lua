--calculates the nth fibonacci number. Breaks for negative or non-integer n.
function fibs(n)
  return n < 2 and n or fibs(n - 1) + fibs(n - 2)
end

--more pedantic version, returns 0 for non-integer n
function pfibs(n)
  if n ~= math.floor(n) then return 0
  elseif n < 0 then return pfibs(n + 2) - pfibs(n + 1)
  elseif n < 2 then return n
  else return pfibs(n - 1) + pfibs(n - 2)
  end
end

--tail-recursive
function a(n,u,s) if n<2 then return u+s end return a(n-1,u+s,u) end
function trfib(i) return a(i-1,1,0) end

--table-recursive
fib_n = setmetatable({1, 1}, {__index = function(z,n) return n<=0 and 0 or z[n-1] + z[n-2] end})

--table-recursive done properly (values are actually saved into table; also the first element
-- of Fibonacci sequence is 0, so the initial table should be {0, 1}).
fib_n = setmetatable({0, 1}, {
  __index = function(t,n)
    if n <= 0 then return 0 end
    t[n] = t[n-1] + t[n-2]
    return t[n]
  end
})

--loop version
function lfibs(n)
  local p0,p1=0,1
  for _=1,n do p0,p1 = p1,p0+p1 end
  return p0
end
