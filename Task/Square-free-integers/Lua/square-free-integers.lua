function squareFree (n)
  for root = 2, math.sqrt(n) do
    if n % (root * root) == 0 then return false end
  end
  return true
end

function run (lo, hi, showValues)
  io.write("From " .. lo .. " to " .. hi)
  io.write(showValues and ":\n" or " = ")
  local count = 0
  for i = lo, hi do
    if squareFree(i) then
      if showValues then
        io.write(i, "\t")
      else
        count = count + 1
      end
    end
  end
  print(showValues and "\n" or count)
end

local testCases = {
  {1, 145, true},
  {1000000000000, 1000000000145, true},
  {1, 100},
  {1, 1000},
  {1, 10000},
  {1, 100000},
  {1, 1000000}
}
for _, example in pairs(testCases) do run(unpack(example)) end
