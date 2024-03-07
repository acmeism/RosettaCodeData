import "io" for File
import "random" for Random
import "./seq" for Lst

// puctuation to keep (also keep hyphen and apostrophe but don't count as words)
var ending  = ".!?"
var pausing = ",:;"

// puctuation to remove
var removing = "\"#$\%&()*+/<=>@[\\]^_`{|}~“”"

// read in book
var fileName = "36-0.txt"  // local copy of http://www.gutenberg.org/files/36/36-0.txt
var text = File.read(fileName)

// skip to start
var ix = text.indexOf("No one would have believed")
text = text[ix..-1]

// remove extraneous punctuation
for (r in removing) text = text.replace(r, "")

// replace EM DASH (unicode 8212) with a space
text = text.replace("—", " ")

// split into words
var words = text.split(" ").where { |w| w != "" }.toList
// treat 'ending' and 'pausing' punctuation as words
for (i in 0...words.count) {
    var w = words[i]
    for (p in ending + pausing) if (w.endsWith(p)) words[i] = [w[0...-1], w[-1]]
}
words = Lst.flatten(words)

// Keep account of what words follow words and how many times it is seen
var dict1 = {}
for (i in 0...words.count-1) {
    var w1 = words[i]
    var w2 = words[i+1]
    if (dict1[w1]) {
        dict1[w1].add(w2)
    } else {
        dict1[w1] = [w2]
    }
}
for (key in dict1.keys) dict1[key] = [dict1[key].count, Lst.individuals(dict1[key])]

// Keep account of what words follow two words and how many times it is seen
var dict2 = {}
for (i in 0...words.count-2) {
    var w12 = words[i] + " " + words[i+1]
    var w3  = words[i+2]
    if (dict2[w12]) {
        dict2[w12].add(w3)
    } else {
        dict2[w12] = [w3]
    }
}
for (key in dict2.keys) dict2[key] = [dict2[key].count, Lst.individuals(dict2[key])]

var rand = Random.new()

var weightedRandomChoice = Fn.new { |value|
    var n = value[0]
    var indivs = value[1]
    var r = rand.int(n)
    var sum = 0
    for (indiv in indivs) {
        sum = sum + indiv[1]
        if (r < sum) return indiv[0]
    }
}

// build 5 random sentences say
for (i in 1..5) {
    var sentence = weightedRandomChoice.call(dict1["."])
    var lastOne = sentence
    var lastTwo = ". " + sentence
    while (true) {
        var nextOne = weightedRandomChoice.call(dict2[lastTwo])
        sentence = sentence + " " + nextOne
        if (ending.contains(nextOne)) break // stop on reaching ending punctuation
        lastTwo = lastOne + " " + nextOne
        lastOne = nextOne
    }

    // tidy up sentence
    for (p in ending + pausing) sentence = sentence.replace(" %(p)", "%(p)")
    sentence = sentence.replace("\n", " ")
    System.print(sentence)
    System.print()
}
