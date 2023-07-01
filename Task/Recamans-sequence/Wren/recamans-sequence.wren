var a = [0]
var used = { 0: true }
var used1000 = { 0: true }
var foundDup = false
var n = 1
while (n <= 15 || !foundDup || used1000.count < 1001) {
    var next = a[n-1] - n
    if (next < 1 || used[next]) next = next + 2*n
    var alreadyUsed = used[next]
    a.add(next)
    if (!alreadyUsed) {
        used[next] = true
        if (next >= 0 && next <= 1000) used1000[next] = true
    }
    if (n == 14) System.print("The first 15 terms of the Recaman's sequence are:\n%(a)")
    if (!foundDup && alreadyUsed) {
        System.print("The first duplicated term is a[%(n)] = %(next)")
        foundDup = true
    }
    if (used1000.count == 1001) {
        System.print("Terms up to a[%(n)] are needed to generate 0 to 1000")
    }
    n = n + 1
}
