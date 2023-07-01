function sumdigits(n)
  local sum = 0
  while n > 0 do
    sum = sum + n % 10
    n = math.floor(n/10)
  end
  return sum
end

primegen:generate(nil, 500)
aprimes = primegen:filter(function(n) return primegen.tbd(sumdigits(n)) end)
print(table.concat(aprimes, " "))
print("Count:", #aprimes)
