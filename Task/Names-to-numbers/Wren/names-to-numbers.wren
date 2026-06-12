import "./str" for Str
import "./pattern" for Pattern
import "./fmt" for Fmt
var names = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
    "ten": 10,
    "eleven": 11,
    "twelve": 12,
    "thirteen": 13,
    "fourteen": 14,
    "fifteen": 15,
    "sixteen": 16,
    "seventeen": 17,
    "eighteen": 18,
    "nineteen": 19,
    "twenty": 20,
    "thirty": 30,
    "forty": 40,
    "fifty": 50,
    "sixty": 60,
    "seventy": 70,
    "eighty": 80,
    "ninety": 90,
    "hundred": 100,
    "thousand": 1e3,
    "million": 1e6,
    "billion": 1e9,
    "trillion": 1e12,
    "quadrillion": 1e15
}

var zeros = ["zero", "nought", "nil", "none", "nothing"]

var seps = Pattern.new("[,|-| and | ]")

var nameToNum = Fn.new { |name|
    var text = Str.lower(name.trim())
    var isNegative = text.startsWith("minus ")
    if (isNegative) text = text[6..-1]
    if (text.startsWith("a ")) text = "one" + text[1..-1]
    var words = seps.splitAll(text).where { |w| w != "" }.toList
    var size = words.count
    if (size == 1 && zeros.contains(words[0])) return 0
    var multiplier = 1
    var lastNum = 0
    var sum = 0
    for (i in size-1..0) {
        var num = names[words[i]]
        if (!num) Fiber.abort("'%(words[i])' is not a valid number")
        if (num == lastNum) Fiber.abort("'%(name)' is not a well formed numeric string")
        if (num >= 1000) {
            if (lastNum >= 100) {
                Fiber.abort("'%(name)' is not a well formed numeric string")
            }
            multiplier = num
            if (i == 0) sum = sum + multiplier
        } else if (num >= 100) {
            multiplier = multiplier * 100
            if (i == 0) sum = sum + multiplier
        } else if (num >= 20) {
            if (lastNum >= 10 && lastNum <= 90) {
                Fiber.abort("'%(name)' is not a well formed numeric string")
            }
            sum = sum + num*multiplier
        } else {
             if (lastNum >= 1 && lastNum <= 90) {
                Fiber.abort("'%(name)' is not a well formed numeric string")
            }
            sum = sum + num*multiplier
        }
        lastNum = num
    }
    return (isNegative) ? -sum : sum
}

var tests = [
    "none",
    "one",
    "twenty-five",
    "minus one hundred and seventeen",
    "hundred and fifty-six",
    "minus two thousand two",
    "nine thousand, seven hundred, one",
    "minus six hundred and twenty six thousand, eight hundred and fourteen",
    "four million, seven hundred thousand, three hundred and eighty-six",
    "fifty-one billion, two hundred and fifty-two million, seventeen thousand, one hundred eighty-four",
    "two hundred and one billion, twenty-one million, two thousand and one",
    "minus three hundred trillion, nine million, four hundred and one thousand and thirty-one",
    "one quadrillion and one",
    "minus nine quadrillion, one hundred thirty-seven"
]
for (name in tests) Fmt.print("$17d = $s", nameToNum.call(name), name)
