import "/fmt" for Fmt
import "/sort" for Sort
import "/iterate" for Stepped

var dna = "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG" +
          "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG" +
          "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT" +
          "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT" +
          "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG" +
          "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA" +
          "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT" +
          "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG" +
          "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC" +
          "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT"

System.print("SEQUENCE:")
var le = dna.count
for (i in Stepped.new(0...le, 50)) {
    var k = i + 50
    if (k > le) k = le
    System.print("%(Fmt.d(5, i)): %(dna[i...k])")
}
var baseMap = {} // allows for 'any' base
for (i in 0...le) {
    var d = dna[i]
    var v = baseMap[d]
    baseMap[d] = !v ? 1 : v + 1
}
var bases = baseMap.keys.toList
Sort.quick(bases)

System.print("\nBASE COUNT:")
for (base in bases) {
    System.print("    %(base): %(Fmt.d(3, baseMap[base]))")
}
System.print("    ------")
System.print("    Σ: %(le)")
System.print("    ======")
