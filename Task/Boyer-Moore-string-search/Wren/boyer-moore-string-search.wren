class BoyerMoore {
    /**
     * Returns the index within this string of the first occurrence of the
     * specified substring. If it is not a substring, return -1.
     *
     * There is no Galil because it only generates one match.
     *
     * @param haystack The string to be scanned
     * @param needle The target string to search
     * @return The start index of the substring
     */
    static indexOf(haystack, needle) {
        haystack = haystack.bytes.toList
        needle = needle.bytes.toList
        var nc = needle.count
        if (nc == 0) return 0
        var charTable = makeCharTable_(needle)
        var offsetTable = makeOffsetTable_(needle)
        var i = nc - 1
        while (i < haystack.count) {
            var j = nc - 1
            while (needle[j] == haystack[i]) {
                if (j == 0) return i
                i = i - 1
                j = j - 1
            }
            i = i + offsetTable[nc - 1 - j].max(charTable[haystack[i]])
        }
        return -1
    }

    /**
     * Makes the jump table based on the mismatched character information.
     */
    static makeCharTable_(needle) {
        var ALPHABET_SIZE = 256 // use bytes rather than codepoints
        var nc = needle.count
        var table = List.filled(ALPHABET_SIZE, nc)
        for (i in 0...nc) table[needle[i]] = nc - 1 - i
        return table
    }

    /**
     * Makes the jump table based on the scan offset which mismatch occurs.
     * (bad character rule).
     */
    static makeOffsetTable_(needle) {
        var nc = needle.count
        var table = List.filled(nc, 0)
        var lastPrefixPosition = nc
        for (i in nc...0) {
            if (isPrefix_(needle, i)) lastPrefixPosition = i
            table[nc-1] = lastPrefixPosition - i - nc
        }
        for (i in 0...nc-1) {
            var slen = suffixLength_(needle, i)
            table[slen] = nc - 1 - i + slen
        }
        return table
    }

    /**
     * Is needle[p..-1] a prefix of needle?
     */
    static isPrefix_(needle, p) {
        var i = p
        var j = 0
        var nc = needle.count
        while (i < nc) {
            if (needle[i] != needle[j]) return false
            i = i + 1
            j = j + 1
        }
        return true
    }

    /**
     * Returns the maximum length of the substring ends at p and is a suffix.
     * (good suffix rule)
     */
   static suffixLength_(needle, p) {
        var len = 0
        var nc = needle.count
        var i = p
        var j = nc - 1
        while (i >= 0 && needle[i] == needle[j]) {
            len = len + 1
            i = i - 1
            j = j - 1
        }
        return len
    }
}

/*
 * Uses the BoyerMoore class to find the indices of ALL matches (overlapping or not)
 *  of the specified substring and return a list of them.
 *  Returns an empty list if it's not a substring.
 */
var indicesOf = Fn.new { |haystack, needle|
    var indices = []
    var hc = haystack.bytes.count
    var start = 0
    while (true) {
        var haystack2 = haystack[start..-1]
        var index = BoyerMoore.indexOf(haystack2, needle)
        if (index == -1) return indices
        indices.add(start + index)
        start = start + index + 1
        if (start >= hc) return indices
    }
}

var texts = [
    "GCTAGCTCTACGAGTCTA",
    "GGCTATAATGCGTA",
    "there would have been a time for such a word",
    "needle need noodle needle",
"InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented",
    "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk.",
    "Due to a malfunction, alfredo halfheartedly wore calfskin severalfold on behalf of alfa.",
    "alfalfa",
    "zzzzzz"
]
var pats = ["TCTA", "TAATAAA", "word", "needle", "put", "and", "alfalfa", "alfa", "alfa", "zzz"]
for (i in 0...texts.count) System.print("text%(i+1) = %(texts[i])")
System.print()
for (i in 0...pats.count) {
    var j = (i < 5) ? i : i-1
    System.print("Found '%(pats[i])' in 'text%(j+1)' at indices %(indicesOf.call(texts[j], pats[i]))")
}
