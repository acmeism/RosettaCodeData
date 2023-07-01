import Foundation

let out = NSOutputStream(toFileAtPath: "/dev/stderr", append: true)
let err = "Goodbye, World!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
out?.open()
let success = out?.write(UnsafePointer<UInt8>(err!.bytes), maxLength: err!.length)
out?.close()

if let bytes = success {
    println("\nWrote \(bytes) bytes")
}
