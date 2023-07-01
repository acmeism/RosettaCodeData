local function carpet(n, f)
  print("n = " .. n)
  local function S(x, y)
    if x==0 or y==0 then return true
    elseif x%3==1 and y%3==1 then return false end
    return S(x//3, y//3)
  end
  for y = 0, 3^n-1 do
    for x = 0, 3^n-1 do
      io.write(f(S(x, y)))
    end
    print()
  end
  print()
end

for n = 0, 4 do
  carpet(n, function(b) return b and "■ " or "  " end)
end
