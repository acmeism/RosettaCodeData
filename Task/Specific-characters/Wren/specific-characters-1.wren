import "./seq" for Lst

var specific = Fn.new { |strings|
    var sc = strings.count
    var res = List.filled(sc, 0)
    var uniqs = List.filled(sc, 0)
    for (i in 0...sc) {
        var s = strings[i].toList
        var indivs = Lst.individuals(s)
        uniqs[i] = indivs.count
        var eligibles = indivs.where { |ind| ind[1] == 2 }.map { |ind| ind[0] }
        var ec = 0
        for (e in eligibles) {
            var found = false
            for (j in 0...sc) {
                if (i == j) continue
                if (strings[j].contains(e)) {
                    found = true
                    break
                }
            }
            if (!found) ec = ec + 1
        }
        res[i] = ec
    }
    var res2 = (0...sc).map { |i| uniqs[i] - res[i] }.toList
    return [res, res2]
}

System.print(specific.call(["ahwiueshaiu","ajxxfioaaf","ajrdsfroiwr"]))
