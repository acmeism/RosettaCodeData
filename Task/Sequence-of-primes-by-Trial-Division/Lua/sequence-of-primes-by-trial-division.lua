function isPrime (n)  -- Function to test primality by trial division
	if n < 2 then return false end
	if n < 4 then return true end
	if n % 2 == 0 then return false end
	for d = 3, math.sqrt(n), 2 do
		if n % d == 0 then return false end
	end
	return true
end

local start = arg[1] or 1	-- Default limits may be overridden with
local bound = arg[2] or 100	-- command line arguments, for example:
							-- lua primes.lua 1000 2000
for i = start, bound do
	if isPrime(i) then io.write(i .. " ") end
end
