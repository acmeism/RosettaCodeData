// call a function with no args
noArgs()

// call a function with one arg with no external name
oneArgUnnamed(1)

// call a function with one arg with external name
oneArgNamed(arg: 1)

// call a function with two args with no external names
twoArgsUnnamed(1, 2)

// call a function with two args and external names
twoArgsNamed(arg1: 1, arg2: 2)

// call a function with an optional arg
// with arg
optionalArguments(arg: 1)
// without
optionalArguments() // defaults to 0

// function that takes another function as arg
funcArg(noArgs)

// variadic function
variadic(opts: "foo", "bar")

// getting a return value
let foo = returnString()

// getting a bunch of return values
let (foo, bar, baz) = returnSomeValues()

// getting a bunch of return values, discarding second returned value
let (foo, _, baz) = returnSomeValues()
