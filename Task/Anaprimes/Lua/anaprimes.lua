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
   for k = 1, 9 do
      out = out .. t[k] .. "_"
   end
   out = out .. t[10]

   return out
end


--[[
   Find all anaprime classes whose elements
   have at most n digits in the list of prime
   numbers primes.

   Also return a list prime_marks so that
   prime_marks[k] is the smallest prime number
   p to verify p > k*mark_step.
--]]
function anaprime(n, primes)
   local classes = {}
   local p = primes[1]
   local k = 1
   local p_lim = 10^n - 1

   local prime_marks = {}

   -- Lower this value for faster results
   -- when n is small.
   local mark_step = math.max(10^(n-5), 100)
   local mark = mark_step

   while p and (p < p_lim) do
      local c = digits_list(p)

      if classes[c] then
	 classes[c] = classes[c] + 1
      else
	 classes[c] = 1
      end

      if p > mark then
	 table.insert(prime_marks, k)
	 mark = mark + mark_step
      end
      k = k + 1; p = primes[k]
   end

   return classes, prime_marks
end


--[[
   Return a list out containing all the
   largest classes found in argument classes.

   The cardinality of these classes is stored
   in out[0].
--]]
function largest_class(classes)
   local out = {}
   local max_card = 0

   for _, card in pairs(classes) do
      if card > max_card then
	 max_card = card
      end
   end
   for c, card in pairs(classes) do
      if card == max_card then
	 table.insert(out, c)
      end
   end

   out[0] = max_card
   return out
end


--[[
   Generate a sorted list of all elements
   in a class c.
--]]
function make_class(c, primes, prime_marks)
   local ctab = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

   for k = 1, 10 do
      local l = 2*(k - 1) + 1
      ctab[k] = tonumber(string.sub(c, l, l))
   end

   local pow = 1
   local pmax = 0
   for k = 1, 10 do
      local ck = ctab[k]
      for l = 1, ck do
	 pmax = pmax + (k - 1) * pow
	 pow = 10*pow
      end
   end

   local pmin = tonumber(string.reverse(pmax))

   local kmin = 1 local kmax
   local k = 1 local kp = #primes
   while k < #prime_marks do
      kp = prime_marks[k]
      local p = primes[kp]

      if p < pmin then
	 kmin = kp
      elseif p > pmax then break
      end
      k = k + 1
   end
   kmax = kp
   if primes[kp] < pmax then kmax = #primes end

   local out = {}
   for k = kmin, kmax do
      local p = primes[k]
      if digits_list(p) == c then
	 table.insert(out, p)
      end
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
print("--- Generating prime numbers...")
local nmax = 9; local p_lim = 10^nmax - 1
local primes = sieve(p_lim)
local classes local prime_marks
local hline = "-----------------------------------------\n"

for n = 3, nmax do
   print(hline .. "Max number of digits: " ..
	 n .."\n--- Searching for all classes...")
   classes, prime_marks= anaprime(n, primes)

   print("--- Searching largest classes...")
   local lc = largest_class(classes)


   print("Cardinality of largest classes: "
      .. lc[0] .. "\n\n" .. #lc ..
      " largest classes found, their respective"
      .. "\nminimum and maximum values are:\n")

   local out = ""
   for k = 1, #lc do
      local c = make_class(lc[k], primes,
			   prime_marks)
      out = out .. " -  " .. c[1] .. "  " ..
	 c[#c] .. "\n"
   end

   print(out)
end

