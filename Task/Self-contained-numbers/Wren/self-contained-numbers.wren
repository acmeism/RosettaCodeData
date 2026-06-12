var res = []
var i = 1
while (res.count < 7) {
    var j = i
    while (j != 1) {
        if (j % 2 == 0) j = j / 2 else j = 3 * j + 1
        if (j % i == 0) {
            res.add(i)
            break
        }
    }
    i = i + 2
}
System.print("The first 7 self-contained numbers are:")
System.print(res)
