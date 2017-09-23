function iter(a, b, c)
  local i = 0
  return function()
    i = i + 1
    return a[i], b[i], c[i]
  end
end

for u, v, w in iter(a1, a2, a3) do print(u..v..w) end
