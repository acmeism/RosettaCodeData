// A common Swift beginner trap
func addToArray(_ arr: [Int]) {
  var arr = arr // Trying to modify arr directly is an error, parameters are immutable
  arr.append(2)
}

let array = [1]
addToArray(array)
print(array) // [1], because value types are pass by copy, array is immutable
