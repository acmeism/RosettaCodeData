import "random" for Random
import "./ioutil" for File, Input
import "./str" for Str
import "./sort" for Find

var rand = Random.new()
var words = File.read("unixdict.txt").trim().split("\n")

var player1 = Input.text("Player 1, please enter your name : ", 1)
var player2 = Input.text("Player 2, please enter your name : ", 1)
if (player2 == player1) player2 = player2 + "2"

var words3or4 = words.where { |w| w.count == 3 || w.count == 4 }.toList
var n = words3or4.count
var firstWord = words3or4[rand.int(n)]
var prevLen = firstWord.count
var prevWord = firstWord
var used = []
var player = player1
System.print("\nThe first word is %(firstWord)\n")
while (true) {
    var word = Str.lower(Input.text("%(player), enter your word : ", 1))
    var len = word.count
    var ok = false
    if (len < 3) {
        System.print("Words must be at least 3 letters long.")
    } else if (Find.first(words, word) == -1) {
        System.print("Not in dictionary.")
    } else if (used.contains(word)) {
        System.print("Word has been used before.")
    } else if (word == prevWord) {
        System.print("You must change the previous word.")
    } else if (len == prevLen) {
        var changes = 0
        for (i in 0...len) {
            if (word[i] != prevWord[i]) {
                changes = changes + 1
            }
        }
        if (changes > 1) {
            System.print("Only one letter can be changed.")
        } else ok = true
    } else if (len == prevLen + 1) {
        var addition = false
        var temp = word
        for (i in 0...prevLen) {
            if (word[i] != prevWord[i]) {
                addition = true
                temp = Str.delete(temp, i)
                if (temp == prevWord) {
                    ok = true
                }
                break
            }
        }
        if (!addition) ok = true
        if (!ok) System.print("Invalid addition.")
    } else if (len == prevLen - 1) {
        var deletion = false
        var temp = prevWord
        for (i in 0...len) {
            if (word[i] != prevWord[i]) {
                deletion = true
                temp = Str.delete(temp, i)
                if (temp == word) {
                    ok = true
                }
                break
            }
        }
        if (!deletion) ok = true
        if (!ok) System.print("Invalid deletion.")
    } else {
        System.print("Invalid change.")
    }
    if (ok) {
        prevLen = word.count
        prevWord = word
        used.add(word)
        player = (player == player1) ? player2 : player1
    } else {
        System.print("So, sorry %(player), you've lost!")
        return
    }
}
