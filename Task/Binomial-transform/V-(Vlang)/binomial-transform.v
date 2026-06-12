const sequences = [
	[i64(1), 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845]
	[i64(0), 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0]
	[i64(0), 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181]
	[i64(1), 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37]
]

const names = [
	'Catalan number sequence:',
	'Prime flip-flop sequence:',
	'Fibonacci number sequence:',
	'Padovan number sequence:',
]	

fn main() {
    for i, seq in sequences {
        println(names[i])
        println(seq.str())
        println('Forward binomial transform:')
        println(forward(seq).str())
        println('Inverse binomial transform:')
        println(inverse(seq).str())
        println('Round trip:')
        println(inverse(forward(seq)).str())
        println('Self-inverting:')
        println(self_inverting(seq).str())
        println('Round trip self-inverting:')
        println(self_inverting(self_inverting(seq)).str())
        println('')
    }
}

fn self_inverting(numbers []i64) []i64 {
    mut transform := []i64{len: numbers.len, init: 0}
    for n in 0 .. numbers.len {
        for k in 0 .. n + 1 {
            sign := if k % 2 == 1 { -1 } else { 1 }
            transform[n] += binomial(n, k) * numbers[k] * sign
        }
    }
    return transform
}

fn inverse(numbers []i64) []i64 {
    mut transform := []i64{len: numbers.len, init: 0}
    for n in 0 .. numbers.len {
        for k in 0 .. n + 1 {
            sign := if (n - k) % 2 == 1 { -1 } else { 1 }
            transform[n] += binomial(n, k) * numbers[k] * sign
        }
    }
    return transform
}

fn forward(numbers []i64) []i64 {
    mut transform := []i64{len: numbers.len, init: 0}
    for n in 0 .. numbers.len {
        for k in 0 .. n + 1 {
            transform[n] += binomial(n, k) * numbers[k]
        }
    }
    return transform
}

fn binomial(n int, k int) i64 {
    return factorial(n) / factorial(n - k) / factorial(k)
}

fn factorial(number int) i64 {
	mut fact := i64(1)
    if number > 20 { panic('Factorial of number is too large: $number') }
    if number < 2 { return 1 }
    for i in 2 .. number + 1 {
        fact *= i
    }
    return fact
}
