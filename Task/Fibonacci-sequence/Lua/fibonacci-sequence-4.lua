fib_n = setmetatable({1, 1}, {__index = function(z,n) return n<=0 and 0 or z[n-1] + z[n-2] end})
