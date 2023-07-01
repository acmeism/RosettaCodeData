import "random" for Random
import "/fmt" for Fmt

var rand = Random.new()

var doTrials = Fn.new{ |trials, np, strategy|
    var pardoned = 0
    for (t in 0...trials) {
        var drawers = List.filled(100, 0)
        for (i in 0..99) drawers[i] = i
        rand.shuffle(drawers)
        var nextTrial = false
        for (p in 0...np) {
            var nextPrisoner = false
            if (strategy == "optimal") {
                var prev = p
                for (d in 0..49) {
                    var curr = drawers[prev]
                    if (curr == p) {
                        nextPrisoner = true
                        break
                    }
                    prev = curr
                }
            } else {
                var opened = List.filled(100, false)
                for (d in 0..49) {
                    var n
                    while (true) {
                        n = rand.int(100)
                        if (!opened[n]) {
                            opened[n] = true
                            break
                        }
                    }
                    if (drawers[n] == p) {
                        nextPrisoner = true
                        break
                    }
                }
            }
            if (!nextPrisoner) {
               nextTrial = true
               break
            }
        }
        if (!nextTrial) pardoned = pardoned + 1
    }
    var rf = pardoned/trials * 100
    Fmt.print("  strategy = $-7s  pardoned = $,6d relative frequency = $5.2f\%\n", strategy, pardoned, rf)
}

var trials = 1e5
for (np in [10, 100]) {
    Fmt.print("Results from $,d trials with $d prisoners:\n", trials, np)
    for (strategy in ["random", "optimal"]) doTrials.call(trials, np, strategy)
}
