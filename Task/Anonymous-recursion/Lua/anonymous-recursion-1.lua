local function Y(x) return (function (f) return f(f) end)(function(y) return x(function(z) return y(y)(z) end) end) end

return Y(function(fibs)
  return function(n)
    return n < 2 and 1 or fibs(n - 1) + fibs(n - 2)
  end
end)
