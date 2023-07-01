import "./pattern" for Pattern
import "./iterate" for Indexed

var map = { "?": "Q", "!": "E", ".": "S", "": "N" }
var p = Pattern.new("[? |! |. ]")
var paras = [
    "hi there, how are you today? I'd like to present to you the washing machine 9001. You have been nominated to win one of these! Just make sure you don't break it",
    "hi there, how are you on St.David's day (isn't it a holiday yet?), Mr.Smith? I'd like to present to you (well someone has to win one!) the washing machine 900.1. You have been nominated by Capt.Johnson('?') to win one of these! Just make sure you (or Mrs.Smith) don't break it. By the way, what the heck is an exclamatory question!?"
]

for (para in paras) {
    para = para.trim()
    var sentences = p.splitAll(para)
    var endings = p.findAll(para).map { |m| m.text[0] }.toList
    var lastChar = sentences[-1][-1]
    if ("?!.".contains(lastChar)) {
        endings.add(lastChar)
        sentences[-1] = sentences[-1][0...-1]
    } else {
        endings.add("")
    }
    for (se in Indexed.new(sentences)) {
        var ix = se.index
        var sentence = se.value
        System.print("%(map[endings[ix]]) <- %(sentence + endings[ix])")
    }
    System.print()
}
