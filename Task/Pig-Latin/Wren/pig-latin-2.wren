import "./str" for Str, Char
import "./pattern" for Pattern

var pigLatin = Fn.new { |word|
    if (word == "") return word
    var vowels = "aeiou"
    var w = Str.lower(word)
    var res
    if (!vowels.contains(w[0])) {
        w = w.replace("qu", "q")
        for (i in 0...w.count) {
            if (vowels.contains(w[0])) break
            w = Str.lshift(w, 1)
            vowels = "aeiouy"
        }
        res = Str.replace(w, "q", "qu", -1)
        if (vowels.contains(res[0])) res = res + "ay"
    } else {
        res = word + "way"
    }
    if (Str.allUpper(Str.replace(word, "'", "", -1))) {
        res = Str.upper(res)
    } else if (Char.isUpper(word[0])) {
        res = Str.capitalize(res)
    }
    return res
}

var sentences = [
    "",
    " ",
    "123456!",
    "Stop! In the name of Wuv!",
    "hello world",
    "pig  latin",
    "rosetta code",
    "the quick brown fox jumps over the lazy dog",
    "pig",
    "black",
    "a",
    "open",
    "by the way",
    "Hello, World!",
    "ALL CAPITALS",
    "ytterbium",
    "boatyard",
    "o'hare O'HARE o'hare don't",
    "'ulu"
]

var  i = Pattern.alpha + "'"
var p1 = Pattern.new("+1/I", 0, i)
var p2 = Pattern.new("+1/i", 0, i)

for (sentence in sentences) {
    var words = p1.splitAll(sentence)
    var seps  = p2.splitAll(sentence)
    var wc = words.count
    var sc = seps.count
    var res = ""
    for (i in 0...wc.min(sc)) res = res + seps[i] + pigLatin.call(words[i])
    if (wc < sc) {
        res = res + seps[-1]
    } else if (sc < wc) {
        res = res + pigLatin.call(words[-1])
    }
    System.print("[%(sentence)] -> [%(res)]")
}
