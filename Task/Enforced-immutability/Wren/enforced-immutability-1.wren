class A {
    construct new(f) {
        _f  = f  // sets field _f to the argument f
    }

    // getter property to allow access to _f
    f { _f }

    // setter property to allow _f to be mutated
    f=(other) { _f = other }
}

var a = A.new(6)
System.print(a.f)
a.f = 8
System.print(a.f)
