import "./upc" for Graphemes

var printCounts = Fn.new { |s1, s2, c1, c2|
   var l1 = (c1 > c2) ? [s1, c1] : [s2, c2]
   var l2 = (c1 > c2) ? [s2, c2] : [s1, c1]
   System.print(  "%(l1[0]) : length %(l1[1])")
   System.print(  "%(l2[0]) : length %(l2[1])\n")
}

var codepointCounts = Fn.new { |s1, s2|
   var c1 = s1.count
   var c2 = s2.count
   System.print("Comparison by codepoints:")
   printCounts.call(s1, s2, c1, c2)
}

var byteCounts = Fn.new { |s1, s2|
   var c1 = s1.bytes.count
   var c2 = s2.bytes.count
   System.print("Comparison by bytes:")
   printCounts.call(s1, s2, c1, c2)
}

var graphemeCounts = Fn.new { |s1, s2|
   var c1 = Graphemes.clusterCount(s1)
   var c2 = Graphemes.clusterCount(s2)
   System.print("Comparison by grapheme clusters:")
   printCounts.call(s1, s2, c1, c2)
}

for (pair in [ ["nino", "niño"], ["👨‍👩‍👧‍👦", "🤔🇺🇸"] ]) {
    codepointCounts.call(pair[0], pair[1])
    byteCounts.call(pair[0], pair[1])
    graphemeCounts.call(pair[0], pair[1])
}

var list = ["abcd", "123456789", "abcdef", "1234567"]
System.write("Sorting in descending order by length in codepoints:\n%(list) -> ")
list.sort { |a, b| a.count > b.count }
System.print(list)
