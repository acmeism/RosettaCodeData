import "random" for Random
import "/sort" for Sort
import "/fmt" for Fmt

var rand = Random.new()

var onesSeq = Fn.new { |n| List.filled(n, 1) }

var shuffledSeq = Fn.new { |n|
    var seq = List.filled(n, 0)
    for (i in 0...n) seq[i] = 1 + rand.int(10 * n)
    return seq
}

var ascendingSeq = Fn.new { |n|
    var seq = shuffledSeq.call(n)
    seq.sort()
    return seq
}

var bubbleSort = Fn.new { |a|
    var n = a.count
    while (true) {
        var n2 = 0
        for (i in 1...n) {
            if (a[i - 1] > a[i]) {
                a.swap(i, i - 1)
                n2 = i
            }
        }
        n = n2
        if (n == 0) break
    }
}

// counting sort of 'a' according to the digit represented by 'exp'
var countSort = Fn.new { |a, exp|
    var n = a.count
    var output = [0] * n
    var count  = [0] * 10
    for (i in 0...n) {
        var t = (a[i]/exp).truncate % 10
        count[t] = count[t] + 1
    }
    for (i in 1..9) count[i] = count[i] + count[i-1]
    for (i in n-1..0) {
        var t = (a[i]/exp).truncate % 10
        output[count[t] - 1] = a[i]
        count[t] = count[t] - 1
    }
    for (i in 0...n) a[i] = output[i]
}

// sorts 'a' in place
var radixSort = Fn.new { |a|
    // check for negative elements
    var min = a.reduce { |m, i| (i < m) ? i : m }
    // if there are any, increase all elements by -min
    if (min < 0) (0...a.count).each { |i| a[i] = a[i] - min }
    // now get the maximum to know number of digits
    var max = a.reduce { |m, i| (i > m) ? i : m }
    // do counting sort for each digit
    var exp = 1
    while ((max/exp).truncate > 0) {
        countSort.call(a, exp)
        exp = exp * 10
    }
    // if there were negative elements, reduce all elements by -min
    if (min < 0) (0...a.count).each { |i| a[i] = a[i] + min }
}

var measureTime = Fn.new { |sort, seq|
    var start = System.clock
    sort.call(seq)
    return ((System.clock - start) * 1e6).round // microseconds
}

var runs = 10
var lengths = [1, 10, 100, 1000, 10000, 50000]
var sorts = [
    bubbleSort,
    Fn.new { |a| Sort.insertion(a) },
    Fn.new { |a| Sort.quick(a) },
    radixSort,
    Fn.new { |a| Sort.shell(a) }
]

var sortTitles = ["Bubble", "Insert", "Quick ", "Radix ", "Shell "]
var seqTitles  = ["All Ones", "Ascending", "Shuffled"]
var totals = List.filled(seqTitles.count, null)
for (i in 0...totals.count) {
    totals[i] = List.filled(sorts.count, null)
    for (j in 0...sorts.count) totals[i][j] = List.filled(lengths.count, 0)
}
var k = 0
for (n in lengths) {
    var seqs = [onesSeq.call(n), ascendingSeq.call(n), shuffledSeq.call(n)]
    for (r in 0...runs) {
        for (i in 0...seqs.count) {
            for (j in 0...sorts.count) {
                var seq = seqs[i].toList
                totals[i][j][k] = totals[i][j][k] + measureTime.call(sorts[j], seq)
            }
        }
    }
    k = k + 1
}
System.print("All timings in microseconds\n")
System.write("Sequence length")
for (len in lengths) Fmt.write("$8d   ", len)
System.print("\n")
for (i in 0...seqTitles.count) {
    System.print("  %(seqTitles[i]):")
    for (j in 0...sorts.count) {
        System.write("    %(sortTitles[j])     ")
        for (k in 0...lengths.count) {
            var time = (totals[i][j][k] / runs).round
            Fmt.write("$8d   ", time)
        }
        System.print()
    }
    System.print("\n")
}
