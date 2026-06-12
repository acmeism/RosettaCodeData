import "random" for Random
import "./ioutil" for Input
import "./fmt" for Fmt
import "./perm" for Comb

var nums = ["one", "two", "three"]
var shas = ["solid", "striped", "open"]
var cols = ["red", "green", "purple"]
var syms = ["diamond", "oval", "squiggle"]

var pack = List.filled(81, null)
var i = 0
for (num in 0..2) {
    for (sha in 0..2) {
        for (col in 0..2) {
            for (sym in 0..2) {
                pack[i] = [nums[num], shas[sha], cols[col], syms[sym]]
                i = i + 1
            }
        }
    }
}

var printCards = Fn.new { |cards|
    for (card in cards) {
        var pl = card[0] != "one" ? "s" : ""
        Fmt.print("$s $s $s $s$s", card[0], card[1], card[2], card[3], pl)
    }
}

var findSets = Fn.new { |cards|
    var sets = []
    var trios = Comb.list(cards, 3)
    for (trio in trios) {
        var t1 = trio[0]
        var t2 = trio[1]
        var t3 = trio[2]
        var found = true
        for (i in 0..3) {
            if (t1[i] == t2[i] && t2[i] == t3[i]) continue
            if (t1[i] != t2[i] && t2[i] != t3[i] && t1[i] != t3[i]) continue
            found = false
            break
        }
        if (found) sets.add(trio)
    }
    Fmt.print("Sets present: $d\n", sets.count)
    if (sets.count > 0) {
        for (set in sets) {
            printCards.call(set)
            System.print()
        }
    }
}

var prompt = "Enter number of cards to deal - 3 to 81 or q to quit: "
Input.quit = "q"
while(true) {
    Random.new().shuffle(pack) // shuffle for each deal
    var i = Input.integer(prompt, 3, 81)
    if (i == Input.quit) return
    var dealt = pack[0...i]
    System.print()
    printCards.call(dealt)
    System.print()
    findSets.call(dealt)
}
