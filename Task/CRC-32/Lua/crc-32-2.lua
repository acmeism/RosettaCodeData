function crc32(buf, size)
  local crc = 0xFFFFFFFF
  local table = {}
  local rem, c

  -- calculate CRC-table
  for i = 0, 0xFF do
    rem = i
    for j = 1, 8 do
      if (rem & 1 == 1) then
        rem = rem >> 1
        rem = rem ~ 0xEDB88320
      else
        rem = rem >> 1
      end
    end
    table[i] = rem
  end

  for x = 1, size do
    c = buf[x]
    crc = (crc >> 8) ~ table[(crc & 0xFF) ~ c]
  end
  return crc ~ 0xFFFFFFFF
end


local str = "The quick brown fox jumps over the lazy dog"
local t = {}
for i = 1, #str do
  t[i] = str:byte(i)
end

print(string.format("CRC32: %x", crc32(t,#str)))
