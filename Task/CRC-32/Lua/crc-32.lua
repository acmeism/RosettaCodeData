local compute=require"zlib".crc32()
local sum=compute("The quick brown fox jumps over the lazy dog")
print(string.format("0x%x", sum))
