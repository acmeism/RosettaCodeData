var block = Block()
let message:[UInt32] = [ 0x65_73_6f_52, 0x20_61_74_74, 0x65_64_6f_43, 0x00_00_00_80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 96, 0 ]
block.compress(message)
let digest = NSString(format: "%2x%2x%2x%2x%2x", UInt32(bigEndian: block.hash[0]), UInt32(bigEndian: block.hash[1]),UInt32(bigEndian: block.hash[2]), UInt32(bigEndian: block.hash[3]), UInt32(bigEndian: block.hash[4]))
println(digest)
