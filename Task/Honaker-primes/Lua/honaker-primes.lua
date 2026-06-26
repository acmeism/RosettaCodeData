--[[
   Return true if an integer n > 1
   is a prime number.
--]]
function is_prime(n)
   local d = 2 local out = true

   while d*d <= n do
      if n % d == 0 then
	 out = false
	 break
      end
      d = d + 1
   end

   return out
end


--[[
   Return the digital sum of an integer n >= 0.
--]]
function digital_sum(n)
   local out = 0
   local nstr = tostring(n)

   for k=1,#nstr,1 do
      local dstr = string.sub(nstr, k, k)
      out = out + tonumber(dstr)
   end

   return out
end


--[[
   Find the n first Honaker primes,
   with their position in the sequence of
   prime numbers.
--]]
function honaker_primes(n)
   local out = {}
   local pos = 1 local p = 2

   while #out < n do

      while not is_prime(p) do
	 p = p + 1
      end

      while digital_sum(p) ~= digital_sum(pos)
      do
	 -- find next prime number
	 p = p + 1; pos = pos + 1
	 while not is_prime(p) do
	    p = p + 1
	 end
      end

      -- new Honaker prime found!
      out[#out + 1] = {pos, p}
      p = p + 1; pos = pos + 1
   end

   return out
end

print("The first fifty Honaker primes.\n")
local l = honaker_primes(50)
print("pos\t:\tvalue")
print("-------------------------")
for k,v in pairs(l) do
   print(v[1] .. "\t:\t" .. v[2])
end

print("\nThe ten thousandth Honaker prime.\n")
l = honaker_primes(10000)
print("pos\t:\tvalue")
print("-------------------------")
print(l[10000][1] .. "\t:\t" .. l[10000][2])
