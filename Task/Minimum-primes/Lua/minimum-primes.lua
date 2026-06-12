require "math"
require "io"

local function isprime(n)
    if n <= 1 then
        return false
    end

    for i=2, math.sqrt(n) do
        if math.mod(n, i) == 0 then
            return false
        end
    end

    return true
end

local function nextprime(n)
    while true do
        n = n + 1
        if isprime(n) then
            return n
        end
    end
end

local function get_next_prime(n)
    if isprime(n) then
        return n
    end

    return nextprime(n)
end

local nums1 = { 5,45,23,21,67 }
local nums2 = { 43,22,78,46,38 }
local nums3 = { 9,98,12,54,53 }

local primes = {}

for i=1, #nums1 do
    local m = math.max(nums1[i], nums2[i], nums3[i])
    primes[#primes+1] = get_next_prime(m)
end

io.write('[')
for i=1, #primes do
   io.write(primes[i])
   if i ~= #primes then
    io.write(',')
   end
end
io.write(']\n')
