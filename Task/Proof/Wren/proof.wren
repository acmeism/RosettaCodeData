import "./fmt" for Fmt

// Represents a natural number.
class Number {
    // Returns a Number with a null predecessor representing the natural number 0.
    static zero { Number.new() }

    // Generates a natural number from a non-negative integer.
    static gen(n) {
        if (n.type != Num || !n.isInteger || n < 0) Fiber.abort("Argument must be a non-negative integer.")
        if (n > 0) return add1(gen(n-1))
        return zero
    }

    // Increments a natural number.
    static add1(x) {
        if (x.type != Number) Fiber.abort("Argument must be a Number.")
        var y = Number.new()
        y.pred = x
        return y
    }

    // Decrements a natural number.
    static sub1(x) {
        if (x.type != Number) Fiber.abort("Argument must be a Number.")
        return x.pred
    }

    // Counts a natural number i.e returns its integer representation.
    static count(x) {
        if (x.type != Number) Fiber.abort("Argument must be a Number.")
        if (x.isZero) return 0
        return count(sub1(x)) + 1
    }

    // Constructs a new Number object with a null predecessor.
    construct new() { _pred = null }

    // Get or set predecessor.
    pred { _pred }
    pred=(p) {
        if (p.type != Number) Fiber.abort("Argument must be a Number.")
        _pred = p
    }

    // Tests whether the current instance is zero.
    isZero { _pred == null }

    // Add another Number.
    +(other) {
        if (other.type != Number) Fiber.abort("Argument must be a Number.")
        if (other.isZero) return this
        return Number.add1(this) + Number.sub1(other)
    }
}

// Represents an even natural number: 2 * half.
class EvenNumber {
    // Counts an even natural number i.e returns its integer representation.
    static count(x) {
        if (x.type != EvenNumber) Fiber.abort("Argument must be an EvenNumber.")
        return Number.count(x.half) * 2
    }

    // Constructs a new EvenNumber object : 2 * half.
    construct new(half) {
        if (half.type != Number) Fiber.abort("Argument must be a Number.")
        _half = half
    }

    // gets 'half' field
    half { _half }

   // Add another EvenNumber.
   +(other) {
        if (other.type != EvenNumber) Fiber.abort("Argument must be an EvenNumber.")
        if (other.half.isZero) return this
        return EvenNumber.new(this.half + other.half)
    }
}

// Represents an odd natural number: 2 * half + 1.
class OddNumber {
    // Counts an odd natural number i.e returns its integer representation.
    static count(x) {
        if (x.type != OddNumber) Fiber.abort("Argument must be an OddNumber.")
        return Number.count(x.half) * 2  + 1
    }

    // Constructs a new OddNumber object : 2 * half + 1.
    construct new(half) {
        if (half.type != Number) Fiber.abort("Argument must be a Number.")
        _half = half
    }

    // gets 'half' field
    half { _half }

    // Add another OddNumber. Note that it returns an EvenNumber.
    +(other) {
        if (other.type != OddNumber) Fiber.abort("Argument must be an OddNumber.")
        var z = this.half + other.half
        return EvenNumber.new(Number.add1(z))
    }
}

// Tests if even number addition is commutative for given numbers.
var testCommutative = Fn.new { |e1, e2|
    if (e1.type != EvenNumber || e2.type != EvenNumber) Fiber.abort("Arguments must be EvenNumbers.")
    var c1 = EvenNumber.count(e1)
    var c2 = EvenNumber.count(e2)
    var passed = EvenNumber.count(e1 + e2) == EvenNumber.count(e2 + e1)
    var symbol = passed ? "==" : "!="
    Fmt.print("\n$d + $d $s $d + $d", c1, c2, symbol, c2, c1)
}

// Tests if even number arithmetic is associative for given numbers.
var testAssociative = Fn.new { |e1, e2, e3|
    if (e1.type != EvenNumber || e2.type != EvenNumber || e3.type != EvenNumber) {
        Fiber.abort("Arguments must be EvenNumbers.")
    }
    var c1 = EvenNumber.count(e1)
    var c2 = EvenNumber.count(e2)
    var c3 = EvenNumber.count(e3)
    var passed = EvenNumber.count((e1 + e2) + e3) == EvenNumber.count(e1 + (e2 + e3))
    var symbol = passed ? "==" : "!="
    Fmt.lprint("\n($d + $d) + $d $s $d + ($d + $d)", [c1, c2, c3, symbol, c1, c2, c3])
}

var numbers = List.filled(10, null)
System.print("The first 10 natural numbers are:")
for (i in 0..9) {
    numbers[i] = Number.gen(i)
    Fmt.write("$d ", Number.count(numbers[i]))
}

System.print("\n\nThe first 10 even natural numbers are:")
for (i in 0..9) {
    var e = EvenNumber.new(numbers[i])
    Fmt.write("$d ", EvenNumber.count(e))
}

System.print("\n\nThe first 10 odd natural numbers are:")
for (i in 0..9) {
    var o = OddNumber.new(numbers[i])
    Fmt.write("$d ", OddNumber.count(o))
}

System.write("\n\nThe sum of the first 10 natural numbers is: ")
var sum = numbers[0]
for (i in 1..9) {
    sum = sum + numbers[i]
}
System.print(Number.count(sum))

System.write("\nThe sum of the first 10 even natural numbers (increasing order) is: ")
var sumEven = EvenNumber.new(numbers[0])
for (i in 1..9) {
    sumEven = sumEven + EvenNumber.new(numbers[i])
}
System.print(EvenNumber.count(sumEven))

System.write("\nThe sum of the first 10 even natural numbers (decreasing order) is: ")
sumEven = EvenNumber.new(numbers[9])
for (i in 8..0) {
    sumEven = sumEven + EvenNumber.new(numbers[i])
}
System.print(EvenNumber.count(sumEven))

testCommutative.call(EvenNumber.new(numbers[8]), EvenNumber.new(numbers[9]))
testAssociative.call(EvenNumber.new(numbers[7]), EvenNumber.new(numbers[8]), EvenNumber.new(numbers[9]))
