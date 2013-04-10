package require Tcl 8.6

set data "The quick brown fox jumps over the lazy dog"
puts [format "%x" [zlib crc32 $data]]
