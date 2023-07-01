// No arguments
noArgs()

// Fixed number of arguments
oneArg x

// Optional arguments
// In a normal function:
optionalArgs <| Some(5) <| None
// In a function taking a tuple:
optionalArgsInTuple(Some(5), None)
// In a function in a type:
foo.optionalArgs 5;;
// However, if you want to pass more than one paramter, the arguments must be
// passed in a tuple:
foo.optionalArgs(5, 6)

// Function with a variable number of arguments
variableArgs 5 6 7 // etc...

// Named arguments can only be used in type methods taking a tuple. The
// arguments can appear in any order.
foo.namedArgs(x = 5, y = 6)

// Using a function in a statement
for i = 0 to someFunc() do
    printfn "Something"

// Using a function in a first-class context
funcArgs someFunc

// Obtaining a return value
let x = someFunc()

// Built-in functions: do functions like (+) or (-) count?

// Parameters are normally passed by value (as shown in the previous examples),
// but they can be passed by reference.
// Passing by reference:
refArgs &mutableVal

// Partial application example
let add2 = (+) 2
