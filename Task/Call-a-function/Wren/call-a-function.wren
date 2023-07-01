var f1 = Fn.new { System.print("Function 'f1' with no arguments called.") }
var f2 = Fn.new { |a, b|
    System.print("Function 'f2' with 2 arguments called and passed %(a) & %(b).")
}
var f3 = Fn.new { 42 }  // function which returns a concrete value

f1.call()               // statement context
f2.call(2, 3)           // ditto
var v1 = 8 + f3.call()  // calling function within an expression
var v2 = f3.call()      // obtaining return value
System.print([v1, v2])  // print last two results as a list

class MyClass {
    static m() { System.print("Static method 'm' called.") }

    construct new(x) { _x = x  } // stores 'x' in a field

    x { _x }          // gets the field
    x=(y) { _x = y }  // sets the field to 'y'

    - { MyClass.new(-_x) }         // prefix operator
    +(o) { MyClass.new(_x + o.x) } // infix operator

    toString { _x.toString } // instance method
}

MyClass.m()               // call static method 'm'
var mc1 = MyClass.new(40) // construct 'mc1'
var mc2 = MyClass.new(8)  // construct 'mc2'
System.print(mc1.x)       // print mc1's field using getter
mc1.x = 42                // change mc1's field using setter
System.print(-mc1.x)      // invoke prefix operator -
System.print(mc1 + mc2)   // invoke infix operator +
