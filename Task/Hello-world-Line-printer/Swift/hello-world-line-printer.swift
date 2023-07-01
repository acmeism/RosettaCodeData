import Foundation

let out = NSOutputStream(toFileAtPath: "/dev/lp0", append: true)
let data = "Hello, World!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
out?.open()
out?.write(UnsafePointer<UInt8>(data!.bytes), maxLength: data!.length)
out?.close()
