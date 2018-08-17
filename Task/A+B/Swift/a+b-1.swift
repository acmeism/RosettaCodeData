import Foundation

let input = NSFileHandle.fileHandleWithStandardInput()

let data = input.availableData
let str = NSString(data: data, encoding: NSUTF8StringEncoding)!

let nums = str.componentsSeparatedByString(" ")
let a = (nums[0] as String).toInt()!
let b = (nums[1] as String).toInt()!

print(" \(a + b)")
