N = 8

-- We'll use nil to indicate no queen is present.
grid = {}
for i = 0, N do
  grid[i] = {}
end

function can_find_solution(x0, y0)
  local x0, y0 = x0 or 0, y0 or 1  -- Set default vals (0, 1).
  for x = 1, x0 - 1 do
    if grid[x][y0] or grid[x][y0 - x0 + x] or grid[x][y0 + x0 - x] then
      return false
    end
  end
  grid[x0][y0] = true
  if x0 == N then return true end
  for y0 = 1, N do
    if can_find_solution(x0 + 1, y0) then return true end
  end
  grid[x0][y0] = nil
  return false
end

if can_find_solution() then
  for y = 1, N do
    for x = 1, N do
      -- Print "|Q" if grid[x][y] is true; "|_" otherwise.
      io.write(grid[x][y] and "|Q" or "|_")
    end
    print("|")
  end
else
  print(string.format("No solution for %d queens.\n", N))
end
