import "/math" for Int

var LIMIT = 999999
var primes = Int.primeSieve(LIMIT)

var longestSeq = Fn.new { |dir|
    var pd = 0
    var longSeqs = [[2]]
    var currSeq = [2]
    for (i in 1...primes.count) {
        var d = primes[i] - primes[i-1]
        if ((dir == "ascending" && d <= pd) || (dir == "descending" && d >= pd)) {
            if (currSeq.count > longSeqs[0].count) {
                longSeqs = [currSeq]
            } else if (currSeq.count == longSeqs[0].count) longSeqs.add(currSeq)
            currSeq = [primes[i-1], primes[i]]
        } else {
            currSeq.add(primes[i])
        }
        pd = d
    }
    if (currSeq.count > longSeqs[0].count) {
        longSeqs = [currSeq]
    } else if (currSeq.count == longSeqs[0].count) longSeqs.add(currSeq)
    System.print("Longest run(s) of primes with %(dir) differences is %(longSeqs[0].count):")
    for (ls in longSeqs) {
        var diffs = []
        for (i in 1...ls.count) diffs.add(ls[i] - ls[i-1])
        for (i in 0...ls.count-1) System.write("%(ls[i]) (%(diffs[i])) ")
        System.print(ls[-1])
    }
    System.print()
}

System.print("For primes < 1 million:\n")
for (dir in ["ascending", "descending"]) longestSeq.call(dir)
