var primes = [2, 3, 5, 7, 11, 13, 17]
var count = 0
var d = []
System.print("Strange plus numbers in the open interval (100, 500) are:\n")
for (i in 101..499) {
    d.clear()
    var j = i
    while (j > 0) {
       d.add(j % 10)
       j = (j/10).floor
    }
    if (primes.contains(d[0] + d[1]) && primes.contains(d[1] + d[2])) {
        System.write("%(i) ")
        count = count + 1
        if (count % 10 == 0) System.print()
    }
}
if (count % 10 != 0) System.print()
System.print("\n%(count) strange plus numbers in all.")
