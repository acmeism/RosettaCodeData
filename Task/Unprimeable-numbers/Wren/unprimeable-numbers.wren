import "./fmt" for Fmt
import "./math" for Int

System.print("The first 35 unprimeable numbers are:")
var count = 0                     // counts all unprimeable numbers
var firstNum = List.filled(10, 0) // stores the first unprimeable number ending with each digit
var i = 100
var countFirst = 0
while (countFirst < 10) {
    if (!Int.isPrime(i)) { // unprimeable number must be composite
        var s = "%(i)"
        var le = s.count
        var b = s.bytes.toList
        var outer = false
        for (j in 0...le) {
            for (k in 48..57) {
                if (s[j].bytes[0] != k) {
                    b[j] = k
                    var bb = b.reduce("") { |acc, byte| acc + String.fromByte(byte) }
                    var n = Num.fromString(bb)
                    if (Int.isPrime(n)) {
                        outer = true
                        break
                    }
                }
            }
            if (outer) break
            b[j] = s[j].bytes[0] // restore j'th digit to what it was originally
        }
        if (!outer) {
            var lastDigit = s[-1].bytes[0] - 48
            if (firstNum[lastDigit] == 0) {
                firstNum[lastDigit] = i
                countFirst = countFirst + 1
            }
            count = count + 1
            if (count <= 35) System.write("%(i) ")
            if (count == 35) System.write("\n\nThe 600th unprimeable number is: ")
            if (count == 600) System.print("%(Fmt.dc(0, i))\n")
        }
    }
    i = i + 1
}

System.print("The first unprimeable number that ends in:")
for (i in 0...10) System.print("  %(i) is:  %(Fmt.dc(9, firstNum[i]))")
