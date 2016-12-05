local function compress(uncompressed) -- string
  local dictionary, result, dictSize, w, c = {}, {}, 255, ""
  for i = 0, 255 do
    dictionary[string.char(i)] = i
  end
  for i = 1, #uncompressed do
    c = string.sub(uncompressed, i, i)
    if dictionary[w .. c] then
      w = w .. c
    else
      table.insert(result, dictionary[w])
      dictSize = dictSize + 1
      dictionary[w .. c] = dictSize
      w = c
    end
  end
  if w ~= "" then
    table.insert(result, dictionary[w])
  end
  return result
end

local function decompress(compressed) -- table
  local dictionary, dictSize, entry, result, w, k = {}, 255, "", "", ""
  for i = 0, 255 do
    dictionary[i] = string.char(i)
  end
  for i = 1, #compressed do
    k = compressed[i]
    if dictionary[k] then
      entry = dictionary[k]
    elseif k == dictSize then
      entry = w .. string.sub(w, 1, 1)
    else
      return nil, i
    end
    result = result .. entry
    dictionary[dictSize] = w .. string.sub(entry, 1, 1)
    dictSize = dictSize + 1
    w = entry
  end
  return result
end

local example = "TOBEORNOTTOBEORTOBEORNOT"
local com = compress(example)
local dec = decompress(com)
print(table.concat(com, ", "))
print(dec)
