import "./str" for Str

var numbers = [
    ["fourteen", "14"],
    ["sixteen", "16"],
    ["seventeen", "17"],
    ["eighteen", "18"],
    ["nineteen", "19"],
    ["sixty", "60"],
    ["seventy", "70"],
    ["eighty", "80"],
    ["ninety", "90"],
    ["one", "1"],
    ["two", "2"],
    ["three", "3"],
    ["four", "4"],
    ["five", "5"],
    ["six", "6"],
    ["seven", "7"],
    ["eight", "8"],
    ["nine", "9"],
    ["ten", "10"],
    ["eleven", "11"],
    ["twelve", "12"],
    ["thirteen", "13"],
    ["fifteen", "15"],
    ["twenty", "20"],
    ["thirty", "30"],
    ["forty", "40"],
    ["fifty", "50"],
    ["single", "1"],
]

var punctuation = [
    ["comma", ","],
    ["hyphen", "-"],
    ["apostrophe", "'"],
    ["exclamation", "!"]
]
var letters = "abcdefghijklmnopqrstuvwxyz"
var symbols = ",-'!"

var autogram = Fn.new { |sentence, ignorePunct|
    System.print("Sentence:\n%(sentence)")
    System.print("Ignore punctuation: %(ignorePunct ? "yes" : "no")")
    var s = Str.lower(sentence)
    // get actual character counts
    var countable = ignorePunct ? letters : letters + symbols
    var map = {}
    for (c in s) {
        if (!countable.contains(c)) continue
        if (map.containsKey(c)) {
            map[c] = map[c] + 1
        } else {
            map[c] = 1
        }
    }
    var keys = map.keys.toList.sort{ |i, j| Str.le(i, j) } // sort into lexicographical order
    var charCounts = keys.map { |k| [k, map[k]] }.join(" ")
    System.print("\nActual character counts:")
    System.print(charCounts)

    var map2 = {}
    for (number in numbers) s = s.replace(number[0], number[1])
    if (!ignorePunct) {
        for (punct in punctuation) s = s.replace(punct[0], punct[1])
    }
    var words = Str.splitNoEmpty(s, " ")
    var i = 0
    var wc = words.count
    while (i < wc - 1) {
        if (Str.allDigits(words[i])) {
            if (Str.allDigits(words[i+1]) && i + 2 < wc) {
                var count = Num.fromString(words[i]) + Num.fromString(words[i+1])
                var char = words[i + 2][0]
                map2[char] = count
                i = i + 3
            } else if (i + 1 < wc) {
                var count = Num.fromString(words[i])
                var char = words[i + 1][0]
                map2[char] = count
                i = i + 2
            }
        } else if (words[i].contains("-")) {
            var split = words[i].split("-")
            if (Str.allDigits(split[0]) && Str.allDigits(split[1]) && i + 1 < wc) {
                var count = Num.fromString(split[0]) + Num.fromString(split[1])
                var char = words[i + 1][0]
                map2[char] = count
                i = i + 2
            }
        } else {
            i = i + 1
        }
    }
    var keys2 = map2.keys.toList.sort{ |i, j| Str.le(i, j) }
    var charCounts2 = keys2.map { |k| [k, map2[k]] }.join(" ")
    System.print("\nPurported character counts:")
    System.print(charCounts2)
    System.print("\nIs autogram? %(charCounts == charCounts2)")
}

var tests = [
    ["This sentence employs two a's, two c's, two d's, twenty-eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty-five s's, twenty-three t's, six v's, ten w's, two x's, five y's, and one z.", true],
    ["This sentence employs two a's, two c's, two d's, twenty eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's, ten w's, two x's, five y's, and one z.", true],
    ["Only the fool would take trouble to verify that his sentence was composed of ten a's, three b's, four c's, four d's, forty-six e's, sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's, four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's, forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's, eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens and, last but not least, a single !", false],
    ["This pangram contains four as, one b, two cs, one d, thirty es, six fs, five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns, fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us, seven vs, eight ws, two xs, three ys, & one z.", true],
    ["This sentence contains one hundred and ninety-seven letters: four a's, one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's, twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's, nineteen t's, six u's, seven v's, four w's, four x's, five y's, and one z.", true],
    ["Thirteen e's, five f's, two g's, five h's, eight i's, two l's, three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's, six w's, four x's, two y's.", true],
    ["Fifteen e's, seven f's, four g's, six h's, eight i's, four n's, five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's, three x's.", false],
    ["Sixteen e's, five f's, three g's, six h's, nine i's, five n's, four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's, four z's.", true]
]

for (t in tests) {
    autogram.call(t[0], t[1])
    System.print("=" * 80)
}
