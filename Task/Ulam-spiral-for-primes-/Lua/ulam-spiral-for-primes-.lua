local function ulamspiral(n, f)
  print("n = " .. n)
  local function isprime(p)
    if p < 2 then return false end
    if p % 2 == 0 then return p==2 end
    if p % 3 == 0 then return p==3 end
    local limit = math.sqrt(p)
    for f = 5, limit, 6 do
      if p % f == 0 or p % (f+2) == 0 then return false end
    end
    return true
  end
  local function spiral(x, y)
    if n%2==1 then x, y = n-1-x, n-1-y end
    local m = math.min(x, y, n-1-x, n-1-y)
    return x<y and (n-2*m-2)^2+(x-m)+(y-m) or (n-2*m)^2-(x-m)-(y-m)
  end
  for y = 0, n-1 do
    for x = 0, n-1 do
      io.write(f(isprime(spiral(x,y))))
    end
    print()
  end
  print()
end

-- filling a 132 column terminal (with a 2-wide glyph to better preserve aspect ratio)
ulamspiral(132/2, function(b) return b and "██" or "  " end)
