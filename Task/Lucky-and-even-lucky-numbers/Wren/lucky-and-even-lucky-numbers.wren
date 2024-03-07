import "os" for Process
import "./iterate" for Stepped
import "./str" for Str

var luckyOdd  = List.filled(1e5, 0)
var luckyEven = List.filled(1e5, 0)

var init = Fn.new {
    for (i in 0...1e5) {
        luckyOdd[i]  = i*2 + 1
        luckyEven[i] = i*2 + 2
    }
}

var filterLuckyOdd = Fn.new {
    var n = 2
    while (n < luckyOdd.count) {
        var m = luckyOdd[n-1]
        var end = (luckyOdd.count/m).floor * m - 1
        for (j in Stepped.descend(end..m-1, m)) luckyOdd.removeAt(j)
        n = n + 1
    }
}

var filterLuckyEven = Fn.new {
    var n = 2
    while (n < luckyEven.count) {
        var m = luckyEven[n-1]
        var end = (luckyEven.count/m).floor * m - 1
        for (j in Stepped.descend(end..m-1, m)) luckyEven.removeAt(j)
        n = n + 1
    }
}

var printSingle = Fn.new { |j, odd|
    if (odd) {
        if (j >= luckyOdd.count) Fiber.abort("Argument is too big")
        System.print("Lucky number %(j) = %(luckyOdd[j-1])")
    } else {
        if (j >= luckyEven.count) Fiber.abort("Argument is too big")
        System.print("Lucky even number %(j) = %(luckyEven[j-1])")
    }
}

var printRange = Fn.new { |j, k, odd|
    if (odd) {
        if (k >= luckyOdd.count) Fiber.abort("Argument is too big")
        var rng = luckyOdd.skip(j-1).take(k-j+1).toList
        System.print("Lucky numbers %(j) to %(k) are:\n %(rng)")
    } else {
        if (k >= luckyEven.count) Fiber.abort("Argument is too big")
        var rng = luckyEven.skip(j-1).take(k-j+1).toList
        System.print("Lucky even numbers %(j) to %(k) are:\n %(rng)")
    }
}

var printBetween = Fn.new { |j, k, odd|
    var rng = []
    if (odd) {
        var max = luckyOdd[-1]
        if (j > max || k > max) {
            Fiber.abort("At least one argument is too big")
        }
        for (num in luckyOdd) {
            if (num >= j) {
                if (num > k) break
                rng.add(num)
            }
        }
        System.print("Lucky numbers between %(j) and %(k) are:\n%(rng)")
    } else {
        var max = luckyEven[-1]
        if (j > max || k > max) {
            Fiber.abort("At least one argument is too big")
        }
        for (num in luckyEven) {
            if (num >= j) {
                if (num > k) break
                rng.add(num)
            }
        }
        System.print("Lucky even numbers between %(j) and %(k) are:\n%(rng)")
    }
}

var args = Process.arguments
var argsSize = args.count
if (argsSize < 1 || argsSize > 3) Fiber.abort("There must be between 1 and 3 command line arguments")
init.call()
filterLuckyOdd.call()
filterLuckyEven.call()
var j = Num.fromString(args[0])
if (j.type != Num || !j.isInteger || j < 1) Fiber.abort("First argument must be a positive integer")
if (argsSize == 1) {
    printSingle.call(j, true)
    return
}

if (argsSize == 2) {
    var k = Num.fromString(args[1])
    if (k.type != Num || !k.isInteger) Fiber.abort("Second argument must be an integer")
    if (k >= 0) {
        if (j > k) Fiber.abort("Second argument can't be less than first")
        printRange.call(j, k, true)
    } else {
        var l = -k
        if (j > l) Fiber.abort("The second argument can't be less in absolute value than first")
        printBetween.call(j, l, true)
    }
    return
}

args[2] = Str.lower(args[2])
var odd = (args[2] == "lucky") ? true :
          (args[2] == "evenlucky") ? false : Fiber.abort("Third argument is invalid")

if (args[1] == ",") {
    printSingle.call(j, odd)
    return
}

var k = Num.fromString(args[1])
if (!((k.type == Num && k.isInteger) || (k.type == String && k == ","))) {
    Fiber.abort("Second argument must be an integer or a comma")
}
if (k >= 0) {
    if (j > k) Fiber.abort("Second argument can't be less than first")
    printRange.call(j, k, odd)
} else {
    var l = -k
    if (j > l) Fiber.abort("The second argument can't be less in absolute value than first")
    printBetween.call(j, l, odd)
}
