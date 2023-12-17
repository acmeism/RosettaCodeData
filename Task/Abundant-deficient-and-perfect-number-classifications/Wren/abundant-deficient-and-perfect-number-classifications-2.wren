var maxNumber      = 20000
var abundantCount  = 0
var deficientCount = 0
var perfectCount   = 0

var pds = []
pds.add(0) // element 0
pds.add(0) // element 1
for (i in 2..maxNumber) {
    pds.add(1)
}
for (i in 2..maxNumber) {
    var j = i + i
    while (j <= maxNumber) {
        pds[j] = pds[j] + i
        j = j + i
    }
}
for (n in 1..maxNumber) {
    var pdSum = pds[n]
    if (pdSum < n) {
        deficientCount = deficientCount + 1
    } else if (pdSum == n) {
        perfectCount = perfectCount + 1
    } else { // pdSum >  n
        abundantCount = abundantCount + 1
    }
}

System.print("Abundant : %(abundantCount)")
System.print("Deficient: %(deficientCount)")
System.print("Perfect  : %(perfectCount)")
