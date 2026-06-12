import "./array" for BitArray
import "./fmt" for Fmt

var kr = BitArray.new(1e8)
var first100 = List.filled(100, 0)
var pow10 = {}
kr[1] = true
var n21 = 3
var n31 = 4
var p2 = 1
var p3 = 1
var count = 0
var max = 1e6
var i = 1
var limit = 1
while (count < max) {
    if (i == n21) {
        if (kr[p2]) kr[i] = true
        p2 = p2 + 1
        n21 = n21 + 2
    }
    if (i == n31) {
        if (kr[p3]) kr[i] = true
        p3 = p3 + 1
        n31 = n31 + 3
    }
    if (kr[i]) {
        count = count + 1
        if (count <= 100) first100[count-1] = i
        if (count == limit) {
            pow10[count] = i
            if (limit == max) break
            limit = 10 * limit
        }
    }
    i = i + 1
}

System.print("First 100 elements of Klarner-Rado sequence:")
Fmt.tprint("$3d ", first100, 10)
System.print()
limit = 1
while (limit <= max) {
    Fmt.print("The $,r element: $,d", limit, pow10[limit])
    limit = 10 * limit
}
