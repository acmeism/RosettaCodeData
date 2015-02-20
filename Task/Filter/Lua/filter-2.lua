function filter(t, func)
  for i, v in ipairs(t) do
    if not func(v) then table.remove(t, i) end
  end
end

function even(a) return a % 2 == 0 end

local values = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
filter(values, even)
print(unpack(values))
