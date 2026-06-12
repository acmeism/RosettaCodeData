import "./pattern" for Pattern
import "./str" for Str
import "./upc" for Graphemes

var join = Fn.new { |words, seps|
    var lw = words.count
    var ls = seps.count
    if (lw != ls + 1) {
        Fiber.abort("Mismatch between number of words and separators.")
    }
    var sb = ""
    for (i in 0...ls) {
        sb = sb + words[i]
        sb = sb + seps[i]
    }
    sb = sb + words[lw-1]
    return sb
}

var redact = Fn.new { |text, word, opts|
    var partial = opts.contains("p")
    var overkill = opts.contains("o")
    var insensitive = opts.contains("i")
    var i = " \t\n\r!\"#$\%&()*+,./:;<=>?@[\\]^`{|}~" // all punctuation except -'_
    var p = Pattern.new("+1/i", 0, i)
    var matches = p.findAll(text)
    var seps = Pattern.matchesText(matches)
    var words = p.splitAll(text)
    var expr = insensitive ? Str.lower(word) : word
    var p2 = Pattern.new(expr)
    for (i in 0...words.count) {
        var w = words[i]
        var wl = insensitive ? Str.lower(w) : w
        var m = p2.find(wl)
        if (m && wl.indexOf(m.text + "\u200d") == -1 && wl.indexOf("\u200d" + m.text) == -1) {
            if (overkill) {
                words[i] = "X" * Graphemes.clusterCount(w)
            } else if (!partial) {
                if (wl == m.text) words[i] = "X" * Graphemes.clusterCount(w)
            } else if (partial) {
                var repl = "X" * Graphemes.clusterCount(word)
                words[i] = p2.replaceAll(wl, repl)
            }
        }
    }
    System.print("%(opts) %(join.call(words, seps))\n")
}

var printResults = Fn.new { |text, allOpts, allWords|
    System.print("Text: %(text)\n")
    for (word in allWords) {
        System.print("Redact '%(word)':")
        for (opts in allOpts) redact.call(text, word, opts)
    }
    System.print()
}

var text = "Tom? Toms bottom tomato is in his stomach while playing the \"Tom-tom\" brand tom-toms. That's so tom.
'Tis very tomish, don't you think?"
var allOpts = ["[w|s|n]", "[w|i|n]", "[p|s|n]", "[p|i|n]", "[p|s|o]", "[p|i|o]"]
var allWords = ["Tom", "tom", "t"]
printResults.call(text, allOpts, allWords)

text = "🧑 👨 🧔 👨‍👩‍👦"
allOpts = ["[w]"]
allWords = ["👨", "👨‍👩‍👦"]
printResults.call(text, allOpts, allWords)

text = "Argentina🧑🇦🇹  France👨🇫🇷  Germany🧔🇩🇪  Netherlands👨‍👩‍👦🇳🇱"
allOpts = ["[p]", "[p|o]"]
printResults.call(text, allOpts, allWords)
