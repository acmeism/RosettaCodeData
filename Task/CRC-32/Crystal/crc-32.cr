require "digest/crc32";

p Digest::CRC32.checksum("The quick brown fox jumps over the lazy dog").to_s(16)
