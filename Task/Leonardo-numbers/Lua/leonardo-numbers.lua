function leoNums (n, L0, L1, add)
  local L0, L1, add = L0 or 1, L1 or 1, add or 1
  local lNums, nextNum = {L0, L1}
  while #lNums < n do
    nextNum = lNums[#lNums] + lNums[#lNums - 1] + add
    table.insert(lNums, nextNum)
  end
  return lNums
end

function show (msg, t)
  print(msg .. ":")
  for i, x in ipairs(t) do
    io.write(x .. " ")
  end
  print("\n")
end

show("Leonardo numbers", leoNums(25))
show("Fibonacci numbers", leoNums(25, 0, 1, 0))
