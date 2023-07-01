map = function(f, data)
   local result = {}
   for k,v in ipairs(data) do
      result[k] = f(v)
   end
   return result
end
