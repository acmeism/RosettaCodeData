import "./math" for Int, Nums
import "./seq" for Lst
import "./fmt" for Fmt

var resF = []
var resD = []
var resT = [] // factors only
var n = 2
var factors1 = []
var factors2 = [2]
var factors3 = [3]
var sum1 = 0
var sum2 = 2
var sum3 = 3
var countF = 0
var countD = 0
var countT = 0
while (countT < 1 || countD < 30 || countF < 30) {
    factors1 = factors2
    factors2 = factors3
    factors3 = Int.primeFactors(n+2)
    sum1 = sum2
    sum2 = sum3
    sum3 = Nums.sum(factors3)
    if (countF < 30 && sum1 == sum2) {
        resF.add(n)
        countF = countF + 1
    }
    if (sum1 == sum2 && sum2 == sum3) {
        resT.add(n)
        countT = countT + 1
    }
    if (countD < 30) {
        var factors4 = factors1.toList
        var factors5 = factors2.toList
        Lst.prune(factors4)
        Lst.prune(factors5)
        if (Nums.sum(factors4) == Nums.sum(factors5)) {
            resD.add(n)
            countD = countD + 1
        }
    }
    n = n + 1
}

System.print("First 30 Ruth-Aaron numbers (factors):")
System.print(resF.join(" "))
System.print("\nFirst 30 Ruth-Aaron numbers (divisors):")
System.print(resD.join(" "))
System.print("\nFirst Ruth-Aaron triple (factors):")
System.print(resT[0])

resT = [] // divisors only
n = 2
factors1 = []
factors2 = [2]
factors3 = [3]
sum1 = 0
sum2 = 2
sum3 = 3
countT = 0
while (countT < 1) {
    factors1 = factors2
    factors2 = factors3
    factors3 = Int.primeFactors(n+2)
    Lst.prune(factors3)
    sum1 = sum2
    sum2 = sum3
    sum3 = Nums.sum(factors3)
    if (sum1 == sum2 && sum2 == sum3) {
        resT.add(n)
        countT = countT + 1
    }
    n = n + 1
}

System.print("\nFirst Ruth-Aaron triple (divisors):")
System.print(resT[0])
