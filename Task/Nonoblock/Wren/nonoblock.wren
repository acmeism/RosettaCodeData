import "./math" for Nums

var genSequence // recursive
genSequence = Fn.new { |ones, numZeros|
    if (ones.isEmpty) return ["0" * numZeros]
    var result = []
    for (x in 1...numZeros - ones.count + 2) {
        var skipOne = ones[1..-1]
        for (tail in genSequence.call(skipOne, numZeros - x)) {
            result.add("0" * x + ones[0] + tail)
        }
    }
    return result
}

var printBlock = Fn.new { |data, len|
    var a = data.toList
    var sumChars = Nums.sum(a.map { |c| c.bytes[0] - 48 }.toList)
    System.print("\nblocks %(a), cells %(len)")
    if (len - sumChars <= 0) {
        System.print("No solution")
        return
    }
    var prep = a.map { |c| "1" * (c.bytes[0] - 48) }.toList
    for (r in genSequence.call(prep, len - sumChars + 1)) {
        System.print(r[1..-1])
    }
}

printBlock.call("21", 5)
printBlock.call("", 5)
printBlock.call("8", 10)
printBlock.call("2323", 15)
printBlock.call("23", 5)
