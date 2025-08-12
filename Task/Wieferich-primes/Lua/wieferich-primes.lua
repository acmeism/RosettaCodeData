function prime_sieve(limit)
  local sieve = {}
  for i = 2, limit do sieve[i] = true end
  if limit > 1 then sieve[1] = false end
  for i = 4, limit, 2 do sieve[i] = false end
  local p = 3
  while true do
    local q = p * p
    if q > limit then break end
    if sieve[p] then
      local incr = 2 * p
      for r = q, limit, incr do
        sieve[r] = false
      end
    end
    p = p + 2
  end
  return sieve
end

function modpow(base, exp, mod)
  if mod == 1 then return 0 end
  local result = 1
  base = base % mod
  while exp > 0 do
    if (exp & 1) == 1 then
      result = (result * base) % mod
    end
    base = (base * base) % mod
    exp = exp >> 1
  end
  return result
end

function wieferich_primes(limit)
  local result = {}
  local sieve = prime_sieve(limit)
  for p = 2, limit do
    if sieve[p] and modpow(2, p - 1, p * p) == 1 then
      table.insert(result, p)
    end
  end
  return result
end

local limit = 5000
print('Wieferich primes less than ' .. limit .. ':')
print(table.unpack(wieferich_primes(limit)))
