import "./math" for Int

var perfect = []
var n = 1
while (perfect.count < 20) {
    var tot = n
    var sum = 0
    while (tot != 1) {
        tot = Int.totient(tot)
        sum = sum + tot
    }
    if (sum == n) perfect.add(n)
    n = n + 2
}
System.print("The first 20 perfect totient numbers are:")
System.print(perfect)
