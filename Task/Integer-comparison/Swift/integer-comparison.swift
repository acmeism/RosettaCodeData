import Cocoa

var input = NSFileHandle.fileHandleWithStandardInput()

println("Enter two integers separated by a space: ")

let data = input.availableData
let stringArray = NSString(data: data, encoding: NSUTF8StringEncoding)?.componentsSeparatedByString(" ")
var a:Int!
var b:Int!
if (stringArray?.count == 2) {
    a = stringArray![0].integerValue
    b = stringArray![1].integerValue
}
if (a==b)  {println("\(a) equals \(b)")}
if (a < b) {println("\(a) is less than \(b)")}
if (a > b) {println("\(a) is greater than \(b)")}
