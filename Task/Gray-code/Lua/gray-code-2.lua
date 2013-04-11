local bit = require 'bit'
local gray = require 'gray'

-- simple binary string formatter
local function to_bit_string(n, width)
  width = width or 1
  local output = ""
  while n > 0 do
    output = bit.band(n,1) .. output
    n = bit.rshift(n,1)
  end
  while #output < width do
    output = '0' .. output
  end
  return output
end

for i = 0,31 do
  g = gray.encode(i);
  gd = gray.decode(g);
  print(string.format("%2d : %s => %s => %s : %2d", i,
    to_bit_string(i,5), to_bit_string(g, 5),
    to_bit_string(gd,5), gd))
end
