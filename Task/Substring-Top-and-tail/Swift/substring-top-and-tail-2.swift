let txt = "0123456789"
println(txt[txt.startIndex.successor() ..< txt.endIndex])
println(txt[txt.startIndex             ..< txt.endIndex.predecessor()])
println(txt[txt.startIndex.successor() ..< txt.endIndex.predecessor()])
