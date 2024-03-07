import "random" for Random
import "./sort" for Sort

var rand = Random.new()
var vals = List.filled(6, 0)
while (true) {
    for (i in 0..5) {
        var rns = List.filled(4, 0)
        for (j in 0..3) rns[j] = rand.int(1, 7)
        var sum = rns.reduce { |acc, n| acc + n }
        Sort.insertion(rns)
        vals[i] = sum - rns[0]
    }
    var total = vals.reduce { |acc, n| acc + n }
    if (total >= 75) {
        var fifteens = vals.count { |n| n >= 15 }
        if (fifteens >= 2) {
            System.print("The six values are: %(vals)")
            System.print("Their total is: %(total)")
            break
        }
    }
}
