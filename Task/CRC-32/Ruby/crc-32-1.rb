require 'zlib'
printf "0x%08x\n", Zlib.crc32('The quick brown fox jumps over the lazy dog')
# => 0x414fa339
