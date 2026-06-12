import "./str" for Str

var pigLatin = Fn.new { |sentence|
    var vowels = "aeiou"
    var words = sentence.split(" ")
    for (i in 0...words.count) {
        var word = words[i]
        if (word == "") continue
        for (i in 0...word.count) {
           if (vowels.contains(word[0])) break
           word = Str.lshift(word, 1)
        }
        words[i] = word + "ay"
    }
    return words.join(" ")
}

var sentences = [
    "hello world",
    "pig  latin",
    "rosetta code",
    "the quick brown fox jumps over the lazy dog",
    "by the way"
]

for (sentence in sentences) {
    System.print(pigLatin.call(sentence))
}
