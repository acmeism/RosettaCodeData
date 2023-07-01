local function printspiral(n)
  local function z(x,y)
    local m = math.min(x, y, n-1-x, n-1-y)
    return x<y and (n-2*m-2)^2+(x-m)+(y-m) or (n-2*m)^2-(x-m)-(y-m)
  end
  for y = 1, n do
    for x = 1, n do
      io.write(string.format("%2d ", n^2-z(x-1,y-1)))
    end
    print()
  end
end
printspiral(9)
