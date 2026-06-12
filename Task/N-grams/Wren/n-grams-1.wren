import "./str" for Str
import "./maputil" for MultiSet
import "./fmt" for Fmt

var findNgrams = Fn.new { |n, text|
    text = Str.upper(text)
    var ngrams = {}
    for (i in 0..text.count-n) {
        var ngram = text[i...i+n]
        MultiSet.add(ngrams, ngram)
    }
    return ngrams
}

// sort by decreasing frequency, then by lexicographical order
var comparer = Fn.new { |i, j|
    if (i.value != j.value) return j.value < i.value
    return Str.lt(i.key, j.key)
}

var text = "Live and let live"
for (n in [2, 3, 4]) {
    var ngrams = findNgrams.call(n, text)
    System.print("All %(n)-grams of '%(text)' and their frequencies:")
    var ng = ngrams.toList.sort(comparer).map { |me| "(\"%(me.key)\" : %(me.value))"}
    Fmt.tprint("$s  ", ng, 5)
    System.print()
}
