import "./math" for Int

var limit = 19
var count = 0
var disarium = []
var n = 0
while (count < limit) {
    var sum = 0
    var digits = Int.digits(n)
    for (i in 0...digits.count) sum = sum + digits[i].pow(i+1)
    if (sum == n) {
        disarium.add(n)
        count = count + 1
    }
    n = n + 1
}
System.print("The first 19 Disarium numbers are:")
System.print(disarium)
