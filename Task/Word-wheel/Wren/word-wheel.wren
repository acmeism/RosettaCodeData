import "io" for File
import "./sort" for Sort, Find
import "./seq" for Lst

var letters = ["d", "e", "e", "g", "k", "l", "n", "o","w"]

var words = File.read("unixdict.txt").split("\n")
// get rid of words under 3 letters or over 9 letters
words = words.where { |w| w.count > 2 && w.count < 10 }.toList
var found = []
for (word in words) {
    if (word.indexOf("k") >= 0) {
        var lets = letters.toList
        var ok = true
        for (c in word) {
            var ix = Find.first(lets, c)
            if (ix == - 1) {
                ok = false
                break
            }
            lets.removeAt(ix)
        }
        if (ok) found.add(word)
    }
}

System.print("The following %(found.count) words are the solutions to the puzzle:")
System.print(found.join("\n"))

// optional extra
var mostFound = 0
var mostWords9 = []
var mostLetters = []
// iterate through all 9 letter words in the dictionary
for (word9 in words.where { |w| w.count == 9 }) {
    letters = word9.toList
    Sort.insertion(letters)
    // get distinct letters
    var distinctLetters = Lst.distinct(letters)
    // place each distinct letter in the middle and see what we can do with the rest
    for (letter in distinctLetters) {
        found = 0
        for (word in words) {
            if (word.indexOf(letter) >= 0) {
                var lets = letters.toList
                var ok = true
                for (c in word) {
                    var ix = Find.first(lets, c)
                    if (ix == - 1) {
                        ok = false
                        break
                    }
                    lets.removeAt(ix)
                }
                if (ok) found = found + 1
            }
        }
        if (found > mostFound) {
            mostFound = found
            mostWords9 = [word9]
            mostLetters = [letter]
        } else if (found == mostFound) {
            mostWords9.add(word9)
            mostLetters.add(letter)
        }
    }
}
System.print("\nMost words found = %(mostFound)")
System.print("Nine letter words producing this total:")
for (i in 0...mostWords9.count) {
    System.print("%(mostWords9[i]) with central letter '%(mostLetters[i])'")
}
