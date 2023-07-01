almostfactorial = function(f) return function(n) return n > 0 and n * f(n-1) or 1 end end
almostfibs = function(f) return function(n) return n < 2 and n or f(n-1) + f(n-2) end end
factorial, fibs = Y(almostfactorial), Y(almostfibs)
print(factorial(7))
