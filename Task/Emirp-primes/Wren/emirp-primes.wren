import "/math" for Int

var isEmirp = Fn.new{ |n|
    if (!Int.isPrime(n)) return false
    var ns = "%(n)"
    var rs = ns[-1..0]
    var r = Num.fromString(rs)
    if (r == n) return false
    if (Int.isPrime(r)) return true
    return false
}

System.print("The first 20 emirps are:")
var count = 0
var i = 3
while (count < 20) {
    if (isEmirp.call(i)) {
        count = count + 1
        System.write("%(i) ")
    }
    i = i + 2
}

System.print("\n\nThe emirps between 7700 and 8000 are:")
i = 7701
while (i < 8000) {
    if (isEmirp.call(i)) System.write("%(i) ")
    i = i + 2
}

System.write("\n\nThe 10,000th emirp is ")
count = 0
i = 1
while (count < 10000) {
    i = i + 2
    if (isEmirp.call(i)) {
        count = count + 1
    }
}
System.print(i)
