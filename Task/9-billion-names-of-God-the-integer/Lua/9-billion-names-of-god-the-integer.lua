function nog(n)
  local tri = {{1}}
  for r = 2, n do
    tri[r] = {}
    for c = 1, r do
      tri[r][c] = (tri[r-1][c-1] or 0) + (tri[r-c] and tri[r-c][c] or 0)
    end
  end
  return tri
end

function G(n)
  local tri, sum = nog(n), 0
  for _, v in ipairs(tri[n]) do sum = sum + v end
  return sum
end

tri = nog(25)
for i, row in ipairs(tri) do
  print(i .. ":  " .. table.concat(row, " "))
end
print("G(23) = " .. G(23))
print("G(123) = " .. G(123))
