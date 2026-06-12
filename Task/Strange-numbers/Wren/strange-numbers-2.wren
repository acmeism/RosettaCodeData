var diffs = [-7, -5, -3, -2, 2, 3, 5, 7]
var possibles = List.filled(10, null)
for (i in 0..9) {
    possibles[i] = []
    for (d in diffs) {
        var sum = i + d
        if (sum >= 0 && sum < 10) possibles[i].add(sum)
    }
}

var places = 10
var start = 1
var strangeOnes = [start]
for (i in 2..places) {
    var newOnes = []
    for (n in strangeOnes) {
        for (nextN in possibles[n%10]) newOnes.add(n*10 + nextN)
    }
    strangeOnes = newOnes
}

System.print("Found %(strangeOnes.count) %(places)-digit strange numbers beginning with %(start).")
