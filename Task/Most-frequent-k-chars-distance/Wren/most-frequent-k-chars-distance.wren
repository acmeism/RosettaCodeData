import "./seq" for Lst
import "./sort" for Sort
import "./iterate" for Stepped

var mostFreqKHashing = Fn.new { |input, k|
   var indivs = Lst.individuals(input.toList).map { |indiv| [indiv[0], indiv[1]] }.toList
   var cmp = Fn.new { |p1, p2| (p2[1] - p1[1]).sign }
   Sort.insertion(indivs, cmp)
   return indivs.take(k).reduce("") { |acc, p| acc + "%(p[0])%(String.fromByte(p[1]))" }
}

var mostFreqKSimilarity = Fn.new { |input1, input2|
    var similarity = 0
    for (i in Stepped.new(0...input1.count, 2)) {
        for (j in Stepped.new(0...input2.count, 2)) {
            if (input1[i] == input2[j]) {
                var freq1 = input1[i + 1].bytes[0]
                var freq2 = input2[j + 1].bytes[0]
                if (freq1 == freq2) similarity = similarity + freq1
            }
        }
    }
    return similarity
}

var mostFreqKSDF = Fn.new { |input1, input2, k, maxDistance|
    System.print("input1 : %(input1)")
    System.print("input2 : %(input2)")
    var s1 = mostFreqKHashing.call(input1, k)
    var s2 = mostFreqKHashing.call(input2, k)
    System.write("mfkh(input1, %(k)) = ")
    var i = 0
    for (c in s1) {
        System.write((i % 2 == 0) ? c : c.bytes[0])
        i = i + 1
    }
    System.write("\nmfkh(input2, %(k)) = ")
    i = 0
    for (c in s2) {
        System.write((i % 2 == 0) ? c : c.bytes[0])
        i = i + 1
    }
    var result = maxDistance - mostFreqKSimilarity.call(s1, s2)
    System.print("\nSDF(input1, input2, %(k), %(maxDistance)) = %(result)\n")
}

var pairs = [
    ["research", "seeking"],
    ["night", "nacht"],
    ["my", "a"],
    ["research", "research"],
    ["aaaaabbbb", "ababababa"],
    ["significant", "capabilities"]
]
for (pair in pairs) mostFreqKSDF.call(pair[0], pair[1], 2, 10)

var s1 = "LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV"
var s2 = "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"
mostFreqKSDF.call(s1, s2, 2, 100)
s1 = "abracadabra12121212121abracadabra12121212121"
s2 = s1[-1..0]
mostFreqKSDF.call(s1, s2, 2, 100)
