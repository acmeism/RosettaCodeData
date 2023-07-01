/* svd_emdedded.wren */

import "./fmt" for Fmt

var matrixPrint = Fn.new { |r, c, m|
    for (i in 0...r) {
        System.write("|")
        for (j in 0...c) {
            Fmt.write("$13.10f ", m[i*c + j])
        }
        System.print("\b|")
    }
    System.print()
}

class GSL {
    // returns 'v' in transposed form
    foreign static svd(r, c, a, v, s)
}

var r = 2
var c = 2
var l = r * c
var a = [3, 0, 4, 5]
var v = List.filled(l, 0)
var s = List.filled(l, 0)

GSL.svd(r, c, a, v, s)
System.print("U:")
matrixPrint.call(r, c, a)
System.print("Σ:")
matrixPrint.call(r, c, s)
System.print("VT:")
matrixPrint.call(r, c, v)
