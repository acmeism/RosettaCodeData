-- Bell numbers in Lua
-- db 6/11/2020 (to replace missing original)

local function bellTriangle(n)
  local tri = { {1} }
  for i = 2, n do
    tri[i] = { tri[i-1][i-1] }
    for j = 2, i do
      tri[i][j] = tri[i][j-1] + tri[i-1][j-1]
    end
  end
  return tri
end

local N = 25 -- in lieu of 50, practical limit with double precision floats
local tri = bellTriangle(N)

print("First 15 and "..N.."th Bell numbers:")
for i = 1, 15 do
  print(i, tri[i][1])
end
print(N, tri[N][1])

print()

print("First 10 rows of Bell triangle:")
for i = 1, 10 do
  print("[ " .. table.concat(tri[i],", ") .. " ]")
end
