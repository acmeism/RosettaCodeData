struct Point {
    x int
    y int
}

// main() declaration can be skipped in one file programs
// we can define whether immutable or mutable by using the "mut" keyword

mut p := Point{
    x: 10
    y: 20
}

// struct fields are accessed using a dot

println("Value of p.x is: $p.x")
println("Show the struct:\n $p")

// alternative literal syntax can be used for structs with 3 fields or fewer

p = Point{30, 40}
assert p.x == 30
println("Show the struct again after change:\n $p")
