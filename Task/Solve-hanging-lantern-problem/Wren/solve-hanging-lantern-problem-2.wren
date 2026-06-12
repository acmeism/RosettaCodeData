import "./perm" for Perm
import "./big" for BigInt

var listPerms = Fn.new { |a, rowSize|
    var lows = List.filled(a.count, 0)
    var sum = 0
    var mlist = []
    for (i in 0...a.count) {
        sum = sum + a[i]
        lows[i] = sum
        mlist = mlist + [i+1] * a[i]
    }
    var n = Perm.countDistinct(sum, a)
    System.print("\nList of %(n) permutations for %(a.count) groups and lanterns per group %(a):")
    var count = 0
    for (p in Perm.listDistinct(mlist)) {
        var curr = lows.toList
        var perm = List.filled(sum, 0)
        for (i in 0...sum) {
            perm[i] = curr[p[i]-1]
            curr[p[i]-1] = curr[p[i]-1] - 1
        }
        System.write("%(perm) ")
        count = count + 1
        if (count % rowSize == 0) System.print()
    }
    if (count % rowSize != 0) System.print()
}

System.print("Number of permutations for the lanterns per group shown:")
var n = 0
for (i in 1..9) {
   var a = (1..i).toList
   n = n + i
   System.print("%(a) => %(BigInt.multinomial(n, a))")
}
var a = [1, 3, 3]
System.print("%(a) => %(BigInt.multinomial(7, a))")
a = [10, 14, 12]
System.print("%(a) => %(BigInt.multinomial(36, a))")
listPerms.call([1, 2, 3], 4)
listPerms.call([1, 3, 3], 3)
