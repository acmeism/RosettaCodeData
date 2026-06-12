-- Happy primes - based on the Pluto sample, using a primesieve and code from the Lua Happy numbers sample

-- code from the Happy numbers Lua sample:
function digits(n)
  if n > 0 then return n % 10, digits(math.floor(n/10)) end
end
function sumsq(a, ...)
  return a and a ^ 2 + sumsq(...) or 0
end
local happy = setmetatable({true, false, false, false}, {
      __index = function(self, n)
         self[n] = self[sumsq(digits(n))]
         return self[n]
      end } )
-- end code from the Happy numbers Lua sample

local function is_happy(n) return happy[n] end

-- the isprime function from Purefox's Pluto-int module modified to be stand-alone and Lua 5
local function isprimeW(n)
    if n < 2 then return false end
    if n % 2 == 0 then return n == 2 end
    if n % 3 == 0 then return n == 3 end
    if n % 5 == 0 then return n == 5 end
    local d = 7
    while d * d <= n do
        if n % d == 0 then return false end
        d = d + 4
        if n % d == 0 then return false end
        d = d + 2
        if n % d == 0 then return false end
        d = d + 4
        if n % d == 0 then return false end
        d = d + 2
        if n % d == 0 then return false end
        d = d + 4
        if n % d == 0 then return false end
        d = d + 6
        if n % d == 0 then return false end
        d = d + 2
        if n % d == 0 then return false end
        d = d + 6
    end
    return true
end

local function get_primesieve(maxPrime)   -- return a sieve of primes to maxPrime
    local isPrime = {}
    for i = 1, maxPrime do isPrime[ i ] = i % 2 ~= 0 end
    isPrime[ 1 ]  = false
    isPrime[ 2 ]  = true
    for s = 3, math.floor( math.sqrt( maxPrime ) ), 2 do
        if isPrime[ s ] then
            for p = s * s, maxPrime, s do isPrime[ p ] = false end
        end
    end
    return isPrime
end

local prime = get_primesieve( 7000000 )    -- initial prime sieve with 7 000 000 elements
local function isprime(n)
    if n <= # prime then
        return prime[ n ]
    else
        return isprimeW( n )
    end
end

do
    print("The first 50 happy primes are:")
    local n, hpc = 1, 0
    while hpc < 50 do
        if is_happy(n) and isprime(n) then
            hpc = hpc + 1
            io.write( string.format("%4d ", n))
            if hpc % 10 == 0 then print() end
        end
        n = n + 1
    end
end

do
    local startT = os.clock()
    print("\nPrime\nfraction    Index  Value")
    local hnc, hpc, n, r, ratio = 0, 0, 1, 2, 0.5
    while r <= 17 do
        if is_happy(n) then
            hnc = hnc + 1
            if isprime(n) then hpc = hpc + 1 end
            if hnc > 1 then
                if hpc / hnc <= ratio then
                    local execT = os.clock() - startT
                    print( string.format("1 / %-2d:  %8d  %-9d    %7.1f seconds", r, hnc, n, execT))
                    r = r + 1
                    ratio = 1 / r
                end
            end
        end
        n = n + 1
    end
end
