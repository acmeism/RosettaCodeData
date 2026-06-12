import "./perm" for Perm
import "./math" for Int
import "./fmt" for Fmt

for (start in 1..0) {
    var outer = false
    System.print("The largest pandigital decimal prime which uses all the digits %(start)..n once is:")
    for (n in [7, 4]) {
        var perms = Perm.listLex((start..n).toList)
        for (i in perms.count - 1..0) {
            if (perms[i][-1] % 2 == 0 || perms[i][-1] == 5 || (start == 0 && perms[i][0] == "0")) continue
            var p = Num.fromString(perms[i].join())
            if (Int.isPrime(p)) {
                Fmt.print("$,d\n", p)
                outer = true
                break
            }
        }
        if (outer) break
    }
}
