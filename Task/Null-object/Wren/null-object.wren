// Declare a variable without giving it an explicit value.
var s

// We can now check for nullness in one of these ways.
System.print(s)
System.print(s == null)
System.print(s is Null)
System.print(s.type == Null)

// Similarly, if we define this function without giving it a return value.
var f = Fn.new {
    System.print("I'm a function with no explicit return value.")
}

// And now call it.
var g = f.call()
// We find that the return value is null.
System.print(g)
