class MyClass {
    construct new(a) {
        _a = a // creates an instance field _a automatically
    }
    a { _a } // allow public access to the field
}

var mc = MyClass.new(3)
System.print(mc.a)  // fine
System.print(mc._a) // can't access _a directly as its private to the class
