table.unpack = table.unpack or unpack -- 5.1 compatibility
local nums = {1,2,3,4,5,6,7,8,9}

function add(a,b)
   return a+b
end

function mult(a,b)
   return a*b
end

function cat(a,b)
   return tostring(a)..tostring(b)
end

local function reduce(fun,a,b,...)
   if ... then
      return reduce(fun,fun(a,b),...)
   else
      return fun(a,b)
   end
end

local arithmetic_sum = function (...) return reduce(add,...) end
local factorial5 = reduce(mult,5,4,3,2,1)

print("Σ(1..9)   : ",arithmetic_sum(table.unpack(nums)))
print("5!        : ",factorial5)
print("cat {1..9}: ",reduce(cat,table.unpack(nums)))
