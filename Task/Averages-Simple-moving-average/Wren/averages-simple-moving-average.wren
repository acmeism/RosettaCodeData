import "./fmt" for Fmt

var sma = Fn.new { |period|
    var i = 0
    var sum = 0
    var storage = []
    return Fn.new { |input|
        if (storage.count < period) {
            sum = sum + input
            storage.add(input)
        }
        sum = sum + input - storage[i]
        storage[i] = input
        i = (i+1) % period
        return sum/storage.count
    }
}

var sma3 = sma.call(3)
var sma5 = sma.call(5)
System.print("  x     sma3   sma5")
for (x in [1, 2, 3, 4, 5, 5, 4, 3, 2, 1]) {
    Fmt.precision = 3
    Fmt.print("$5f  $5f  $5f", x, sma3.call(x), sma5.call(x))
}
