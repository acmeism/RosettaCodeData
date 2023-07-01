import "./math" for Int
import "./sort" for Find
import "/fmt" for Fmt

var limit = 4 * 1e8
var c = Int.primeSieve(limit - 1, false)
var compSums = []
var primeSums = []
var csum = 0
var psum = 0
for (i in 2...limit) {
    if (c[i]) {
        csum = csum + i
        compSums.add(csum)
    } else {
        psum = psum + i
        primeSums.add(psum)
    }
}

for (i in 0...primeSums.count) {
    var ix
    if ((ix = Find.first(compSums, primeSums[i])) >= 0) {
        Fmt.print("$,21d - $,12r prime sum, $,12r composite sum", primeSums[i], i+1, ix+1)
    }
}
