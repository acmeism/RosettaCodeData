local _M = {}

local bit  = require('bit')
local math = require('math')

_M.encode = function(number)
  return bit.bxor(number, bit.rshift(number, 1));
end

_M.decode = function(gray_code)
  local value = 0
  while gray_code > 0 do
    gray_code, value = bit.rshift(gray_code, 1), bit.bxor(gray_code, value)
  end
  return value
end

return _M
