var n = 3
var values = ["A", "B", "C", "D"]
var k = values.count

// terminate when first two characters of the permutation are 'B' and 'C' respectively
var decide = Fn.new { |pc| pc[0] == "B" && pc[1] == "C" }

var pn = List.filled(n, 0)
var pc = List.filled(n, null)
while (true) {
    // generate permutation
    var i = 0
    for (x in pn) {
        pc[i] = values[x]
        i = i + 1
    }
    // show progress
    System.print(pc)
    // pass to deciding function
    if (decide.call(pc)) return // terminate early
    // increment permutation number
    i = 0
    while (true) {
        pn[i] = pn[i] + 1
        if (pn[i] < k) break
        pn[i] = 0
        i = i + 1
        if (i == n) return // all permutations generated
    }
}
