--[[
   Return the count of each digit in an
   integer n >= 0 as a literal string.
--]]
function digits_list(n)
   local t = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

   while n ~= 0 do
      local d = n % 10
      t[d + 1] = t[d + 1] + 1
      n = n // 10
   end

   local out = ""
   for k = 1, #t do out = out .. t[k] end

   return out
end


--[[
   Return the list of all Ormiston pairs in
   a list of all prime numbers up to a certain
   limit.
--]]
function ormiston_pairs(primes)
   local out = {}
   local k = 1
   local p = primes[1]
   local q = primes[2]
   local ptab = digits_list(p)

   while q do
      local qtab = digits_list(q)

      if ptab == qtab then
	 table.insert(out, {p, q})
      end
      k = k + 1
      p = q; q = primes[k + 1]
      ptab = qtab
   end

   return out
end


--[[
   Return the list of all prime numbers up
   to n by using the sieve of Atkin.
--]]
function sieve(n)
   local test = {} local out = {}

   test[2] = true; test[3] = true

   local x = 1
   while x*x <= n do
	
      local y = 1
      while y*y <= n do
	 local p = 4*x*x + y*y
	 if p <= n and
	    (p % 12 == 1 or p % 12 == 5) then
	    test[p] = not test[p]
	 end

	 p = 3*x*x + y*y
	 if p <= n and p % 12 == 7 then
	    test[p] = not test[p]
	 end

	 p = 3*x*x - y*y
	 if p <= n and x > y and p % 12 == 11
	 then
	    test[p] = not test[p]
	 end
	 y = y + 1
      end
      x = x + 1
   end

   x = 5
   while x*x <= n do
      if test[x] then
	 for k = x*x, n, x*x do
	    test[k] = nil
	 end
      end
      x = x + 1
   end

   for k = 2, n, 1 do
      if test[k] then
	 table.insert(out, k)
      end
   end

   return out
end


-- MAIN PROGRAM
local n = 1e7
local show_lim = 30
local primes = sieve(n)
local opairs = ormiston_pairs(primes)

local count_1mi = 1
while opairs[count_1mi][2] < 1e6 do
   count_1mi = count_1mi + 1
end

local out = count_1mi .. " Ormiston pairs found "
   .. "between 1 and " .. 1e6 .. ".\n"
out = out .. #opairs .. " Ormiston pairs found "
   .. "between 1 and " .. n .. ".\n\n" ..
   "The first " .. show_lim .. " pairs are:\n"

for k = 1, show_lim do
   out = out .. k;
   if k < 10 then out = out .. " " end
   if opairs[k] then
      out = out .. "| {" .. opairs[k][1] ..
	 ", " .. opairs[k][2] .. "}\n"
   else out = out .. "| nil\n" end
end

print(out)

