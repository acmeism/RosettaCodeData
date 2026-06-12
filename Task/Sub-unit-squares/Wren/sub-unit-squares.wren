import "./math" for Int

System.print("The first 7 sub-unit squares are:")
System.print(1)
var i = 2
var count = 1
while (count < 7) {
    var sq = i * i
    var digits = Int.digits(sq)
    if (digits[0] != 1 && !digits.contains(0)) {
        var sum = digits[0] - 1
        for (i in 1...digits.count) sum = sum * 10  + digits[i] - 1
        if (Int.isSquare(sum)) {
            System.print(sq)
            count = count + 1
        }
    }
    i = i + 1
}
