// To change the value of the variable, after making it mutable with "mut", use "=".

mut age := 20
println(age)
age = 21
println(age)

// For structs, we can define whether immutable or mutable by using the "mut" keyword.
// Outside of a function example:

struct Point {
mut:
    x int
    y int
}

// Inside of a function example; struct usage:

mut p := Point{
    x: 10
    y: 20
}

// Method argument example:

fn (mut arg Point) register() {
    println("Show the struct:\n $arg")
}

// V string individual elements are immutable; we cannot assign to s[i], as will cause an error.

mut s := 'hello'
s[0] = m // not allowed

// Constants are always declared outside of functions in V

const numbers = [1, 2, 3]

fn show() {
	println(numbers)
}
