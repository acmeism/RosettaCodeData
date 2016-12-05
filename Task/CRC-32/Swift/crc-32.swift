import Foundation

let strData = "The quick brown fox jumps over the lazy dog".dataUsingEncoding(NSUTF8StringEncoding,
    allowLossyConversion: false)
let crc = crc32(uLong(0), UnsafePointer<Bytef>(strData!.bytes), uInt(strData!.length))

println(NSString(format:"%2X", crc))
