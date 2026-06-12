import "./str" for Str
import "./ordered" for OrderedBag
import "./fmt" for Fmt

var findNgrams = Fn.new { |n, text|
    text = Str.upper(text)
    var ngrams = OrderedBag.new()
    for (i in 0..text.count-n) {
        var ngram = text[i...i+n]
        ngrams.add(ngram)
    }
    return ngrams
}

var text = "Live and let live"
for (n in [2, 3, 4]) {
    var ngrams = findNgrams.call(n, text)
    System.print("All %(n)-grams of '%(text)' and their frequencies:")
    var ng = ngrams.toList.map { |me| "(\"%(me.key)\" : %(me.value))"}
    Fmt.tprint("$s  ", ng, 5)
    System.print()
}
