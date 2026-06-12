import "./ioutil" for FileUtil
import "./str" for Str
import "random" for Random

var rand = Random.new()

// Get all words in unixdict.txt between 4 and 9 letters long.
var candidates = FileUtil.readLines("unixdict.txt").where { |word|
    var wc = word.count
    return wc > 3 && wc < 10
}.toList
var nc = candidates.count

var passphrase = Fn.new { |n|
    if (n < 3 || n > 7) Fiber.abort("There should be between 3 and 7 words.")
    var rci = []
    var rns = []
    var ppw = []

    // Get 'n' random candidate indices.
    while (rci.count < n) {
        var rn = rand.int(nc)
        if (!rci.contains(rn)) rci.add(rn)
    }

    // Get 'n' random numbers between 10 and 99.
    while (rns.count < n) {
        var rn = rand.int(10, 100)
        if (!rns.contains(rn)) rns.add(rn)
    }

    // Construct and return the passphrase.
    for (i in 0...n) {
        var word = candidates[rci[i]]
        word = Str.capitalize(word)
        ppw.add(word + rns[i].toString)
    }
    return ppw.join("-")
}

// Generate and print 5 passphrases for n = 5.
for (i in 1..5) {
    System.print(passphrase.call(5))
}
