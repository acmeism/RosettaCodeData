class KMP {
    static search(haystack, needle) {
        haystack = haystack.bytes.toList
        needle = needle.bytes.toList
        var hc = haystack.count
        var nc = needle.count
        var indices = []
        var i = 0 // index into haystack
        var j = 0 // index into needle
        var t = table_(needle)
        while (i < hc) {
            if (needle[j] == haystack[i]) {
                i = i + 1
                j = j + 1
            }
            if (j == nc) {
                indices.add(i - j)
                j = t[j-1]
            } else if (i < hc && needle[j] != haystack[i]) {
                if (j != 0) {
                    j = t[j-1]
                } else {
                    i = i + 1
                }
            }
        }
        return indices
    }

    static table_(needle) {
        var nc = needle.count
        var t = List.filled(nc, 0)
        var i = 1   // index into table
        var len = 0 // length of previous longest prefix
        while (i < nc) {
            if (needle[i] == needle[len]) {
               len = len + 1
               t[i] = len
               i = i + 1
            } else if (len != 0) {
                len = t[len-1]
            } else {
                t[i] = 0
                i = i + 1
            }
        }
        return t
    }
}

var texts = [
    "GCTAGCTCTACGAGTCTA",
    "GGCTATAATGCGTA",
    "there would have been a time for such a word",
    "needle need noodle needle",
"InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
    "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk."
]
var pats = ["TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa"]
for (i in 0...texts.count) System.print("text%(i+1) = %(texts[i])")
System.print()
for (i in 0...pats.count) {
    var j = (i < 5) ? i : i-1
    System.print("Found '%(pats[i])' in 'text%(j+1)' at indices %(KMP.search(texts[j], pats[i]))")
}
