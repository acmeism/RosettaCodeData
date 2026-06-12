import "random" for Random
import "./pattern" for Pattern
import "./str" for Str
import "./fmt" for Fmt

var rand = Random.new()
var base = "ACGT"

var findDnaSubsequence = Fn.new { |dnaSize, chunkSize|
    var dnaSeq = List.filled(dnaSize, null)
    for (i in 0...dnaSize) dnaSeq[i] = base[rand.int(4)]
    var dnaStr = dnaSeq.join()
    var dnaSubseq = List.filled(4, null)
    for (i in 0...4) dnaSubseq[i] = base[rand.int(4)]
    var dnaSubstr = dnaSubseq.join()
    System.print("DNA sequence:")
    var i = chunkSize
    for (chunk in Str.chunks(dnaStr, chunkSize)) {
         Fmt.print("$3d..$3d: $s", i - chunkSize + 1, i, chunk)
         i = i + chunkSize
    }
    System.print("\nSubsequence to locate: %(dnaSubstr)")
    var p = Pattern.new(dnaSubstr)
    var matches = p.findAll(dnaStr)
    if (matches.count == 0) {
        System.print("No matches found.")
    } else {
        System.print("Matches found at the following indices:")
        for (m in matches) {
            Fmt.print("$3d..$3d", m.index + 1, m.index + 4)
        }
    }
}

findDnaSubsequence.call(200, 20)
System.print()
findDnaSubsequence.call(600, 40)
