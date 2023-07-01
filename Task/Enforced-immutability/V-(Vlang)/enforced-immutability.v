// To change the value of the variable, after making it mutable with "mut",  use "=".

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

// Inside of a function example:

mut p := Point{
    x: 10
    y: 20
}

// Function argument example:

fn (mut arg Point) register() {
    println("Show the struct:\n $arg")
}

// V string individual elements are immutable, so we cannot assign to s[i], and will get an error.

mut s := 'hello'
s[0] = m // not allowed
