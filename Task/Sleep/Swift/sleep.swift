import Foundation

println("Enter number of seconds to sleep")
let input = NSFileHandle.fileHandleWithStandardInput()
var amount = NSString(data:input.availableData, encoding: NSUTF8StringEncoding)?.intValue
var interval = NSTimeInterval(amount!)
println("Sleeping...")
NSThread.sleepForTimeInterval(interval)

println("Awake!")
