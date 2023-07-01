import "io" for File
import "/str" for Char, Str
import "/sort" for Sort
import "/fmt" for Fmt

var wordList = "unixdict.txt"
var DIGITS = "22233344455566677778889999"
var map = {}
var countValid = 0
var words = File.read(wordList).trimEnd().split("\n")
for (word in words) {
    var valid = true
    var sb = ""
    for (c in Str.lower(word)) {
        if (!Char.isLower(c)) {
            valid = false
            break
        }
        sb = sb + DIGITS[Char.code(c) - 97]
    }
    if (valid) {
        countValid = countValid + 1
        if (map.containsKey(sb)) {
            map[sb].add(word)
        } else {
            map[sb] = [word]
        }
    }
}
var textonyms = map.toList.where { |me| me.value.count > 1 }.toList
var report = "There are %(countValid) words in '%(wordList)' " +
             "which can be represented by the digit key mapping.\n" +
             "They require %(map.count) digit combinations to represent them.\n" +
             "%(textonyms.count) digit combinations represent Textonyms.\n"
System.print(report)

var longest = Sort.merge(textonyms) { |i, j| (j.key.count - i.key.count).sign }
var ambiguous = Sort.merge(longest) { |i, j| (j.value.count - i.value.count).sign }

System.print("Top 8 in ambiguity: \n")
System.print("Count   Textonym  Words")
System.print("======  ========  =====")
var f = "$4d    $-8s  $s"
for (a in ambiguous.take(8)) Fmt.print(f, a.value.count, a.key, a.value)

f = f.replace("8", "14")
System.print("\nTop 6 in length:\n")
System.print("Length  Textonym        Words")
System.print("======  ==============  =====")
for (l in longest.take(6)) Fmt.print(f, l.key.count, l.key, l.value)
