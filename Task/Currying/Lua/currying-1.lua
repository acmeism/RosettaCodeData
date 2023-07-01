function curry2(f)
   return function(x)
      return function(y)
         return f(x,y)
      end
   end
end

function add(x,y)
   return x+y
end

local adder = curry2(add)
assert(adder(3)(4) == 3+4)
local add2 = adder(2)
assert(add2(3) == 2+3)
assert(add2(5) == 2+5)
