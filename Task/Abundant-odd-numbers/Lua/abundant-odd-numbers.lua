-- Return the sum of the proper divisors of x
function sumDivs (x)
  local sum, sqr = 1, math.sqrt(x)
  for d = 2, sqr do
    if x % d == 0 then
      sum = sum + d
      if d ~= sqr then sum = sum + (x/d) end
    end
  end
  return sum
end

-- Return a table of odd abundant numbers
function oddAbundants (mode, limit)
  local n, count, divlist, divsum = 1, 0, {}
  repeat
    n = n + 2
    divsum = sumDivs(n)
    if divsum > n then
      table.insert(divlist, {n, divsum})
      count = count + 1
      if mode == "Above" and n > limit then return divlist[#divlist] end
    end
  until count == limit
  if mode == "First" then return divlist end
  if mode == "Nth" then return divlist[#divlist] end
end

-- Write a result to stdout
function showResult (msg, t)
  print(msg .. ": the proper divisors of " .. t[1] .. " sum to " .. t[2])
end

-- Main procedure
for k, v in pairs(oddAbundants("First", 25)) do  showResult(k, v) end
showResult("1000", oddAbundants("Nth", 1000))
showResult("Above 1e6", oddAbundants("Above", 1e6))
