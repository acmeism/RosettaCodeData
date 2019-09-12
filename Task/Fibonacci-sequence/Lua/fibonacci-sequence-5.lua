-- table recursive done properly (values are actually saved into table;
-- also the first element of Fibonacci sequence is 0, so the initial table should be {0, 1}).
fib_n = setmetatable({0, 1}, {
  __index = function(t,n)
    if n <= 0 then return 0 end
    t[n] = t[n-1] + t[n-2]
    return t[n]
  end
})
