class MyClass { }

func printAddress<T>(of pointer: UnsafePointer<T>) {
    print(pointer)
}

func test() {
    var x = 42
    var y = 3.14
    var z = "foo"
    var obj = MyClass()

    // Use a pointer to a variable on the stack and print its address.
    withUnsafePointer(to: &x)   { print($0) }
    withUnsafePointer(to: &y)   { print($0) }
    withUnsafePointer(to: &z)   { print($0) }
    withUnsafePointer(to: &obj) { print($0) }

    // Alternately:
    printAddress(of: &x)
    printAddress(of: &y)
    printAddress(of: &z)
    printAddress(of: &obj)

    // Printing the address of an object that an object reference points to.
    print(Unmanaged.passUnretained(obj).toOpaque())
}

test()
