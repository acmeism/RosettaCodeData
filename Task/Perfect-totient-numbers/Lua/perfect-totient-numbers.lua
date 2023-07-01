local function phi(n)
   assert(type(n) == 'number', 'n must be a number!')
   local result, i = n, 2
   while i <= n do
      if n % i == 0 then
	 while n % i == 0 do n = n // i end
	 result = result - (result // i)
      end
      if i == 2 then i = 1 end
      i = i + 2
   end
   if n > 1 then result = result - (result // n) end
   return result
end

local function phi_iter(n)
   assert(type(n) == 'number', 'n must be a number!')
   if n == 2 then
      return phi(n) + 0
   else
      return phi(n) + phi_iter(phi(n))
   end
end

local i, count = 2, 0
while count ~= 20 do
   if i == phi_iter(i) then
      io.write(i, ' ')
      count = count + 1
   end
   i = i + 1
end
