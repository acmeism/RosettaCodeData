import "/big" for BigInt
import "/fmt" for Fmt

var bellTriangle = Fn.new { |n|
    var tri = List.filled(n, null)
    for (i in 0...n) {
        tri[i] = List.filled(i, null)
        for (j in 0...i) tri[i][j] = BigInt.zero
    }
    tri[1][0] = BigInt.one
    for (i in 2...n) {
        tri[i][0] = tri[i-1][i-2]
        for (j in 1...i) {
            tri[i][j] = tri[i][j-1] + tri[i-1][j-1]
        }
    }
    return tri
}

var bt = bellTriangle.call(51)
System.print("First fifteen and fiftieth Bell numbers:")
for (i in 1..15) Fmt.print("$2d: $,i", i, bt[i][0])
Fmt.print("$2d: $,i", 50, bt[50][0])
System.print("\nThe first ten rows of Bell's triangle:")
for (i in 1..10) Fmt.print("$,7i", bt[i])
