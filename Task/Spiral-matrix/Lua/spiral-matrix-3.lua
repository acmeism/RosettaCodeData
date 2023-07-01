local function makespiral(n)
  local t, z = {}, function(x,y)
    local m = math.min(x, y, n-1-x, n-1-y)
    return x<y and (n-2*m-2)^2+(x-m)+(y-m) or (n-2*m)^2-(x-m)-(y-m)
  end
  for y = 1, n do t[y] = {}
    for x = 1, n do t[y][x] = n^2-z(x-1,y-1) end
  end
  return t
end
local function printspiral(t)
  for y = 1, #t do
    for x = 1, #t[y] do
      io.write(string.format("%2d ", t[y][x]))
    end
    print()
  end
end
printspiral(makespiral(9))
