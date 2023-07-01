: needleIndex(needle, haystack)
   haystack indexOf(needle) dup ifNull: [ drop ExRuntime throw("Not found", needle) ] ;

[ "Zig", "Zag", "Wally", "Ronald", "Bush", "Krusty", "Charlie", "Bush", "Boz" ] const: Haystack

needleIndex("Bush", Haystack) println
Haystack lastIndexOf("Bush") println
needleIndex("Washington", Haystack) println
