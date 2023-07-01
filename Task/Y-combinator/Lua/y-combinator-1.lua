Y = function (f)
   return function(...)
      return (function(x) return x(x) end)(function(x) return f(function(y) return x(x)(y) end) end)(...)
   end
end
