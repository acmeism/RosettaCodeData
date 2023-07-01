import "/math" for Int
import "/big" for BigInt

var list = (2..20).toList
list.add(65)
for (i in list) {
    if (Int.isPrime(i)) {
        System.print("HP%(i) = %(i)")
        continue
    }
    var n = 1
    var j = BigInt.new(i)
    var h = [j]
    while (true) {
        var k = BigInt.primeFactors(j).reduce("") { |acc, f| acc + f.toString }
        j = BigInt.new(k)
        h.add(j)
        if (j.isProbablePrime(2)) {
            for (l in n...0) System.write("HP%(h[n-l])(%(l)) = ")
            System.print(h[n])
            break
        } else {
            n = n + 1
        }
    }
}
