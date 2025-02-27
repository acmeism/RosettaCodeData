function foldl(func, init, array)
   assert(type(func) == "function", "type(fn) == " .. type(func))
   assert(type(array) == "table", "type(array) == " .. type(array))
   local result = init
   for v in ipairs(array) do
      result = func(result, v)
   end
   return result
end

function add(x, y) return x + y end
mul = function(x, y) return x * y end

nums = {1,2,3,4,5,6,7,8,9}
print("add 1 to 9    ", foldl(add, 0, nums))
print("multiply", foldl(mul, 1, nums))
-- uses anonymous function
print("concatenate",
   foldl(function(x,y) return x .. y end, "", nums))
