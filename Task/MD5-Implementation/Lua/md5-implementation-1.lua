-- shift amounts
local s = {
  7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
  5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20,
  4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
  6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21
}

-- constants
local K = {
  0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
  0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
  0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
  0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
  0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
  0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
  0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
  0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
  0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
  0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
  0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
  0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
  0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
  0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
  0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
  0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
}

local function leftRotate(x, c)
  return (x << c) | (x >> (32-c))
end

local function getInt(byteArray, n)
  return (byteArray[n+3]<<24) + (byteArray[n+2]<<16) + (byteArray[n+1]<<8) + byteArray[n]
end

--- converts 32bit integer n to a little endian hex representation
-- @tparam integer n
local function lE(n)
  local s = ''
  for i = 0, 3 do
    s = ('%s%02x'):format(s, (n>>(i*8))&0xff)
  end
  return s
end

--- md5
-- @tparam string message
local function md5(message)
  local a0, b0, c0, d0 = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
  local bytes = {message:byte(1, -1)}

  -- insert 1 bit (and the rest of the byte)
  table.insert(bytes, 0x80)

  -- pad with zeros until we have *just enough*
  local p = #bytes%64
  if p > 56 then
    p = p - 64
  end
  for _ = p+1, 56 do
    table.insert(bytes, 0)
  end

  -- insert the initial message length, in little-endian
  local len = ((#message)<<3)&0xffffffffffffffff -- length in bits
  for i = 0, 7 do
    table.insert(bytes, (len>>(i*8))&0xff)
  end


  for i = 0, #bytes//64-1 do
    local a, b, c, d = a0, b0, c0, d0
    for j = 0, 63 do
      local F, g
      -- permutate
      if j <= 15 then
        F = (b & c) | (~b & d)
        g = j
      elseif j <= 31 then
        F = (d & b) | (~d & c)
        g = (5*j + 1) & 15
      elseif j <= 47 then
        F = b ~ c ~ d
        g = (3*j + 5) & 15
      else
        F = c ~ (b | ~d)
        g = (7*j) & 15
      end

      F = (F + a + K[j+1] + getInt(bytes, i*64+g*4+1))&0xffffffff
      -- shuffle
      a = d
      d = c
      c = b
      b = (b + leftRotate(F, s[j+1]))&0xffffffff
    end
    -- update internal state
    a0 = (a0 + a)&0xffffffff
    b0 = (b0 + b)&0xffffffff
    c0 = (c0 + c)&0xffffffff
    d0 = (d0 + d)&0xffffffff
  end

  -- lua doesn't support any other byte strings. Could convert to a wacky string but this is more printable.
  return lE(a0)..lE(b0)..lE(c0)..lE(d0)
end

local demo = {
  [""] = "d41d8cd98f00b204e9800998ecf8427e",
  ["a"] = "0cc175b9c0f1b6a831c399e269772661",
  ["abc"] = "900150983cd24fb0d6963f7d28e17f72",
  ["message digest"] = "f96b697d7cb7938d525a2f31aaf161d0",
  ["abcdefghijklmnopqrstuvwxyz"] = "c3fcd3d76192e4007dfb496cca67e13b",
  ["ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"] = "d174ab98d277d9f5a5611c2c9f419d9f",
  ["12345678901234567890123456789012345678901234567890123456789012345678901234567890"] = "57edf4a22be3c955ac49da2e2107b67a",
}

for k, v in pairs(demo) do
  local m = md5(k)
  print(("%s [%2s] <== \"%s\""):format(m, m==v and 'OK' or '', k))
end
