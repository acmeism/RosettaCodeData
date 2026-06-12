var alphabet = "01"

var nextWord = Fn.new { |n, w|
    var x = (w * ((n/w.count).floor + 1))[0...n]
    while (x != "" && x[-1] == alphabet[-1]) x = x[0...-1]
    if (x != "") {
        var lastChar = x[-1]
        var nextCharIndex = alphabet.indexOf(lastChar) + 1
        x = x[0...-1] + alphabet[nextCharIndex]
    }
    return x
}

var generateLyndonWords = Fiber.new { |n|
    var w = alphabet[0]
    while (w.count <= n) {
        Fiber.yield(w)
        w = nextWord.call(n, w)
        if (w == "") break
    }
}

while (true) {
    var word = generateLyndonWords.call(5)
    if (!word) break
    System.print(word)
}
