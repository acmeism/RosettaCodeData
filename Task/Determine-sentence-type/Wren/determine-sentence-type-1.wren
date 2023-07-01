var sentenceType = Fn.new { |s|
    if (s.count == 0) return ""
    var types = []
    for (c in s) {
        if (c == "?") {
            types.add("Q")
        } else if (c == "!") {
            types.add("E")
        } else if (c == ".") {
            types.add("S")
        }
    }
    if (!"?!.".contains(s[-1])) types.add("N")
    return types.join("|")
}

var s = "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it"
System.print(sentenceType.call(s))
