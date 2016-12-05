class MyClass {
}

func printPointer<T>(ptr: UnsafePointer<T>) {
  println(ptr)
}

func test() {
  var x = 42
  var y = 3.14
  var z = "foo"
  var obj = MyClass()

  // Use a pointer to a variable on the stack and print its address
  withUnsafePointer(&x) { ptr in println(ptr) }
  withUnsafePointer(&y) { ptr in println(ptr) }
  withUnsafePointer(&z) { ptr in println(ptr) }
  withUnsafePointer(&obj) { ptr in println(ptr) }

  // Alternately:
  printPointer(&x)
  printPointer(&y)
  printPointer(&z)
  printPointer(&obj)

  // Printing the address of an object that an object reference points to
  // In Swift 3, unsafeAddress is removed
  println(Unmanaged.passUnretained(obj).toOpaque())
}

test()
