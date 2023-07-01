import "/fmt" for Fmt

var names = {
     1: "one",
     2: "two",
     3: "three",
     4: "four",
     5: "five",
     6: "six",
     7: "seven",
     8: "eight",
     9: "nine",
    10: "ten",
    11: "eleven",
    12: "twelve",
    13: "thirteen",
    14: "fourteen",
    15: "fifteen",
    16: "sixteen",
    17: "seventeen",
    18: "eighteen",
    19: "nineteen",
    20: "twenty",
    30: "thirty",
    40: "forty",
    50: "fifty",
    60: "sixty",
    70: "seventy",
    80: "eighty",
    90: "ninety"
}

var bigNames = {
    1e3 : "thousand",
    1e6 : "million",
    1e9 : "billion",
    1e12: "trillion",
    1e15: "quadrillion"
}

var irregOrdinals = {
    "one"   : "first",
    "two"   : "second",
    "three" : "third",
    "five"  : "fifth",
    "eight" : "eighth",
    "nine"  : "ninth",
    "twelve": "twelfth"
}

var strToOrd = Fn.new { |s|
    if (s == "zero") return "zeroth" // or alternatively 'zeroeth'
    var splits = s.replace("-", " ").split(" ")
    var last = splits[-1]
    return irregOrdinals.containsKey(last) ? s[0...-last.count] + irregOrdinals[last] :
           last.endsWith("y") ? s[0...-1] + "ieth" : s + "th"
}

var numToText = Fn.new { |n, uk|
    if (n == 0) return "zero"
    var neg = n < 0
    var nn = neg ? - n : n
    var digits3 = List.filled(6, 0)
    for (i in 0..5) {  // split number into groups of 3 digits from the right
        digits3[i] = nn % 1000
        nn = (nn / 1000).truncate
    }

    var threeDigitsToText = Fn.new { |number|
        var sb = ""
        if (number == 0) return ""
        var hundreds = (number / 100).truncate
        var remainder = number % 100
        if (hundreds > 0) {
            sb = sb + names[hundreds] + " hundred"
            if (remainder > 0) sb = sb + (uk ? " and " : " ")
        }
        if (remainder > 0) {
            var tens = (remainder / 10).truncate
            var units = remainder % 10
            if (tens > 1) {
                sb = sb + names[tens * 10]
                if (units > 0) sb = sb + "-" + names[units]
            } else {
                sb = sb + names[remainder]
            }
        }
        return sb
    }

    var strings = List.filled(6, 0)
    for (i in 0..5) strings[i] = threeDigitsToText.call(digits3[i])
    var text = strings[0]
    var andNeeded = uk && 1 <= digits3[0] && digits3[0] <= 99
    var big = 1000
    for (i in 1..5) {
        if (digits3[i] > 0) {
            var text2 = strings[i] + " " + bigNames[big]
            if (!text.isEmpty) {
                text2 = text2 + (andNeeded ? " and " : " ")  // no commas inserted in this version
                andNeeded = false
            } else {
                andNeeded = uk && 1 <= digits3[i] && digits3[i] <= 99
            }
            text = text2 + text
        }
        big = big * 1000
    }
    if (neg) text = "minus " + text
    return text
}

var opening = "Four is the number of letters in the first word of this sentence,".split(" ")

var adjustedLength = Fn.new { |s|  s.replace(",", "").replace("-", "").count } // no ',' or '-'

var getWords = Fn.new { |n|
    var words = []
    words.addAll(opening)
    if (n > opening.count) {
        var k = 2
        while (true) {
            var len = adjustedLength.call(words[k - 1])
            var text = numToText.call(len, false)
            var splits = text.split(" ")
            words.addAll(splits)
            words.add("in")
            words.add("the")
            var text2 = strToOrd.call(numToText.call(k, false)) + ","  // add trailing comma
            var splits2 = text2.split(" ")
            words.addAll(splits2)
            if (words.count >= n) break
            k = k + 1
        }
    }
    return words
}

var getLengths = Fn.new { |n|
    var words = getWords.call(n)
    var lengths = words.take(n).map { |w| adjustedLength.call(w) }.toList
    // includes hyphens, commas & spaces
    var sentenceLength = words.reduce(0) { |acc, w| acc + w.count } + words.count - 1
    return [lengths, sentenceLength]
}

var getLastWord = Fn.new { |n|
    var words = getWords.call(n)
    var nthWord = words[n - 1]
    var nthWordLength = adjustedLength.call(nthWord)
    // includes hyphens, commas & spaces
    var sentenceLength = words.reduce(0) { |acc, w| acc + w.count } + words.count - 1
    return [nthWord, nthWordLength, sentenceLength]
}

var n = 201
System.print("The lengths of the first %(n) words are:\n")
var res = getLengths.call(n)
var list = res[0]
var sentenceLength = res[1]
for (i in 0...n) {
    if (i % 25 == 0) {
        if (i > 0) System.print()
        Fmt.write("$3d: ", i + 1)
    }
    Fmt.write("$3d", list[i])
}
Fmt.print("\n\nLength of sentence = $,d\n", sentenceLength)

n = 1000
while (true) {
    var res = getLastWord.call(n)
    var word = res[0]
    var wLen = res[1]
    var sLen = res[2]
    if (word.endsWith(",")) word = word[0...-1]  // strip off any trailing comma
    Fmt.print("The length of word $,d [$s] is $d", n, word, wLen)
    Fmt.print("Length of sentence = $,d\n", sLen)
    n = n * 10
    if (n > 1e7) break
}
