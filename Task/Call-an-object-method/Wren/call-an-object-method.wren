class MyClass {
    construct new() {}
    method() { System.print("instance method called") }
    static method() { System.print("static method called") }
}

var mc = MyClass.new()
mc.method()
MyClass.method()
