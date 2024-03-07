import "io" for File
import "./sort" for Find

var words = File.read("unixdict.txt").trim().split("\n")

var oneAway = Fn.new { |a, b|
    var sum = 0
    for (i in 0...a.count) if (a[i] != b[i]) sum = sum + 1
    return sum == 1
}

var wordLadder = Fn.new { |a, b|
    var l = a.count
    var poss = words.where { |w| w.count == l }.toList
    var todo = [[a]]
    while (todo.count > 0) {
        var curr = todo[0]
        todo = todo[1..-1]
        var next = poss.where { |w| oneAway.call(w, curr[-1]) }.toList
        if (Find.first(next, b) != -1) {
            curr.add(b)
            System.print(curr.join(" -> "))
            return
        }
        poss = poss.where { |p| !next.contains(p) }.toList
        for (i in 0...next.count) {
            var temp = curr.toList
            temp.add(next[i])
            todo.add(temp)
        }
    }
    System.print("%(a) into %(b) cannot be done.")
}

var pairs = [
    ["boy", "man"],
    ["girl", "lady"],
    ["john", "jane"],
    ["child", "adult"]
]
for (pair in pairs) wordLadder.call(pair[0], pair[1])
