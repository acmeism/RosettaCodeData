var numbers = Array[I32](16) // creating array of 32-bit ints with initial allocation for 16 elements
numbers.push(10) // add value 10 to the end of array, extending the underlying memory if needed
try
  let x = numbers(0) // fetch the first element of array. index starts at 0
  Fact(x == 10)      // try block is needed, because both lines inside it can throw exception
end

var other: Array[U64] = [10, 20, 30] // array literal
let s = other.size() // return the number of elements in array
try
  Fact(s == 3)  // size of array 'other' is 3
  other(1) = 40 // 'other' now is [10, 40, 30]
end
