package main

import "fmt"

// Represents a natural number.
type Number struct {
    pred *Number
}

// Represents an even natural number: 2 * half.
type EvenNumber struct {
    half *Number
}

// Represents an odd natural number: 2 * half + 1.
type OddNumber struct {
    half *Number
}

// Returns the natural number zero by a nil pointer.
func zero() *Number { return nil }

// Tests whether a natural number is zero.
func isZero(x *Number) bool { return x == nil }

// Increments a natural number.
func add1(x *Number) *Number {
    y := new(Number)
    y.pred = x
    return y
}

// Decrements a natural number.
func sub1(x *Number) *Number { return x.pred }

// Adds two natural numbers.
func add(x, y *Number) *Number {
    if isZero(y) {
        return x
    }
    return add(add1(x), sub1(y))
}

// Adds two even natural numbers.
func addEven(x, y *EvenNumber) *EvenNumber {
    if isZero(y.half) {
        return x
    }
    return genEven(add(x.half, y.half))
}

// Adds two odd natural numbers.
func addOdd(x, y *OddNumber) *EvenNumber {
    z := add(x.half, y.half)
    return genEven(add1(z))
}

// Generate a natural number from a uint.
func gen(n uint) *Number {
    if n > 0 {
        return add1(gen(n - 1))
    }
    return zero()
}

// Generate an even natural number: 2 * half.
func genEven(half *Number) *EvenNumber {
    return &EvenNumber{half}
}

// Generate an odd natural number: 2 * half + 1.
func genOdd(half *Number) *OddNumber {
    return &OddNumber{half}
}

// Counts a natural number i.e returns its integer representation.
func count(x *Number) uint {
    if isZero(x) {
        return 0
    }
    return count(sub1(x)) + 1
}

// Counts an even natural number i.e returns its integer representation.
func countEven(x *EvenNumber) uint {
    return count(x.half) * 2
}

// Counts an odd natural number i.e returns its integer representation.
func countOdd(x *OddNumber) uint {
    return count(x.half)*2 + 1
}

// Test if even number addition is commutative for given numbers.
func testCommutative(e1, e2 *EvenNumber) {
    c1, c2 := countEven(e1), countEven(e2)
    passed := countEven(addEven(e1, e2)) == countEven(addEven(e2, e1))
    symbol := "=="
    if !passed {
        symbol = "!="
    }
    fmt.Printf("\n%d + %d %s %d + %d\n", c1, c2, symbol, c2, c1)
}

// Test if even number arithmetic is associative for given numbers.
func testAssociative(e1, e2, e3 *EvenNumber) {
    c1, c2, c3 := countEven(e1), countEven(e2), countEven(e3)
    passed := countEven(addEven(addEven(e1, e2), e3)) == countEven(addEven(e1, addEven(e2, e3)))
    symbol := "=="
    if !passed {
        symbol = "!="
    }
    fmt.Printf("\n(%d + %d) + %d %s %d + (%d + %d)\n", c1, c2, c3, symbol, c1, c2, c3)
}

func main() {
    numbers := [10]*Number{}
    fmt.Println("The first 10 natural numbers are:")
    for i := uint(0); i < 10; i++ {
        numbers[i] = gen(i)
        fmt.Printf("%d ", count(numbers[i]))
    }
    fmt.Println("\n")

    fmt.Println("The first 10 even natural numbers are:")
    for i := uint(0); i < 10; i++ {
        e := genEven(numbers[i])
        fmt.Printf("%d ", countEven(e))
    }
    fmt.Println("\n")

    fmt.Println("The first 10 odd natural numbers are:")
    for i := uint(0); i < 10; i++ {
        o := genOdd(numbers[i])
        fmt.Printf("%d ", countOdd(o))
    }
    fmt.Println("\n")

    fmt.Print("The sum of the first 10 natural numbers is: ")
    sum := numbers[0]
    for i := 1; i < 10; i++ {
        sum = add(sum, numbers[i])
    }
    fmt.Println(count(sum))

    fmt.Print("\nThe sum of the first 10 even natural numbers (increasing order) is: ")
    sumEven := genEven(numbers[0])
    for i := 1; i < 10; i++ {
        sumEven = addEven(sumEven, genEven(numbers[i]))
    }
    fmt.Println(countEven(sumEven))

    fmt.Print("\nThe sum of the first 10 even natural numbers (decreasing order) is: ")
    sumEven = genEven(numbers[9])
    for i := 8; i >= 0; i-- {
        sumEven = addEven(sumEven, genEven(numbers[i]))
    }
    fmt.Println(countEven(sumEven))

    testCommutative(genEven(numbers[8]), genEven(numbers[9]))

    testAssociative(genEven(numbers[7]), genEven(numbers[8]), genEven(numbers[9]))
}
