/* Super-d_numbers_2.wren */

import "./gmp" for Mpz
import "./fmt" for Fmt

var start = System.clock
var rd = ["22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999"]
for (i in 2..9) {
    Fmt.print("First 10 super-$d numbers:", i)
    var count = 0
    var j = Mpz.three
    var k = Mpz.new()
    while (true) {
        k.pow(j, i).mul(i)
        var ix = k.toString.indexOf(rd[i-2])
        if (ix >= 0) {
            count = count + 1
            Fmt.write("$i ", j)
            if (count == 10) {
                Fmt.print("\nfound in $f seconds\n", System.clock - start)
                break
            }
        }
        j.inc
    }
}
