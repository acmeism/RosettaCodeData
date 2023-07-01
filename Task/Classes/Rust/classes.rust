struct MyClass {
    variable: i32, // member variable = instance variable
}

impl MyClass {
    // member function = method, with its implementation
    fn some_method(&mut self) {
        self.variable = 1;
    }

    // constructor, with its implementation
    fn new() -> MyClass {
        // Here could be more code.
        MyClass { variable: 0 }
    }
}

fn main () {
    // Create an instance in the stack.
    let mut instance = MyClass::new();

    // Create an instance in the heap.
    let mut p_instance = Box::new(MyClass::new());

    // Invoke method on both istances,
    instance.some_method();
    p_instance.some_method();

    // Both instances are automatically deleted when their scope ends.
}
