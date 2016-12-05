// Arrays are typed in Swift, however, using the Any object we can add any type. Swift does not support fixed length arrays
var anyArray = [Any]()
anyArray.append("foo") // Adding to an Array
anyArray.append(1) // ["foo", 1]
anyArray.removeAtIndex(1) // Remove object
anyArray[0] = "bar" // ["bar"]]
