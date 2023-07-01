import Foundation

print("Enter the dimensions of the array seperated by a space (width height): ")

let fileHandle = NSFileHandle.fileHandleWithStandardInput()
let dims = NSString(data: fileHandle.availableData, encoding: NSUTF8StringEncoding)?.componentsSeparatedByString(" ")

if let dims = dims where dims.count == 2{
	let w = dims[0].integerValue
	let h = dims[1].integerValue

	if let w = w, h = h where w > 0 && h > 0 {
		var array = Array<[Int!]>(count: h, repeatedValue: Array<Int!>(count: w, repeatedValue: nil))

		array[0][0] = 2
		println(array[0][0])
		println(array)
	}
}
