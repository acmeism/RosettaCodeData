import "/math" for Int, Nums

var d = 0
var a = 0
var p = 0
for (i in 1..20000) {
    var j = Nums.sum(Int.properDivisors(i))
    if (j < i) {
        d = d + 1
    } else if (j == i) {
        p = p + 1
    } else {
        a = a + 1
    }
}
System.print("There are %(d) deficient numbers between 1 and 20000")
System.print("There are %(a) abundant numbers  between 1 and 20000")
System.print("There are %(p) perfect numbers between 1 and 20000")
