import "./big" for BigInt
import "./fmt" for Fmt

var polydivisible = Fn.new {
    var numbers = []
    var previous = (1..9).toList
    var new = []
    var digits = 2
    while (previous.count > 0) {
        numbers.add(previous)
        for (n in previous) {
            for (j in 0..9) {
                var number = BigInt.ten * n + j
                if (number % digits == 0) new.add(number)
            }
        }
        previous = new
        new = []
        digits = digits + 1
    }
    return numbers
}

var numbers = polydivisible.call()
numbers[0].add(BigInt.zero) // include zero
var total = numbers.reduce(0) { |acc, number| acc + number.count }
Fmt.print("There are $,d magic numbers in total.", total)

var largest = numbers[-1][-1]
Fmt.print("\nThe largest is $,i.", largest)

System.print("\nThere are:")
for (i in 0...numbers.count) {
    Fmt.print("$,5d with $2d digit$s", numbers[i].count, i+1, (i == 0) ? "" : "s")
}

var pd19 = []
for (n in numbers[8]) {
    var s = n.toString
    var pandigital = true
    for (i in 1..9) {
        if (!s.contains(i.toString)) {
            pandigital = false
            break
        }
    }
    if (pandigital) pd19.add(n)
}
System.print("\nAll magic numbers that are pan-digital in 1 through 9 with no repeats: ")
Fmt.print("$,i", pd19)

var pd09 = []
for (n in numbers[9]) {
    var s = n.toString
    var pandigital = true
    for (i in 0..9) {
        if (!s.contains(i.toString)) {
            pandigital = false
            break
        }
    }
    if (pandigital) pd09.add(n)
}
System.print("\nAll magic numbers that are pan-digital in 0 through 9 with no repeats: ")
Fmt.print("$,i", pd09)
