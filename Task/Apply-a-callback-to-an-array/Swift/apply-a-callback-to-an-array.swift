func square(n: Int) -> Int {
    return n * n
}

let numbers = [1, 3, 5, 7]

let squares1a = numbers.map(square)         // map method on array

let squares1b = numbers.map {x in x*x}      // map method on array with anonymous function

let squares1b = numbers.map { $0 * $0 }      // map method on array with anonymous function and unnamed parameters

let isquares1 = numbers.lazy.map(square)   // lazy sequence
