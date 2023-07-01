package require crc32
puts [format "%x" [crc::crc32 $data]]
