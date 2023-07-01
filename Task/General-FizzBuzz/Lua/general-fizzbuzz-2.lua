local function fizzbuzz(n, mods)
  local res = {}

  for i = 1, #mods, 2 do
    local mod, name = mods[i], mods[i+1]
    for i = mod, n, mod do
      res[i] = (res[i] or '') .. name
    end
  end

  for i = 1, n do
    res[i] = res[i] or i
  end

  return table.concat(res, '\n')
end

do
  local n = tonumber(io.read())     -- number of lines, eg. 100
  local mods = {}

  local n_mods = 0
  while n_mods ~= 3 do              -- for reading until EOF, change 3 to -1
    local line = io.read()
    if not line then break end
    local s, e = line:find(' ')
    local num  = tonumber(line:sub(1, s-1))
    local name = line:sub(e+1)
    mods[#mods+1] = num
    mods[#mods+1] = name
    n_mods = n_mods + 1
  end

  print(fizzbuzz(n, mods))
end
