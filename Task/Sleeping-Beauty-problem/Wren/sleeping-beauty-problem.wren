import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()

var sleepingBeauty = Fn.new { |reps|
    var wakings = 0
    var heads = 0
    for (i in 0...reps) {
        var coin = rand.int(2) // heads = 0, tails = 1 say
        wakings = wakings + 1
        if (coin == 0) {
            heads = heads + 1
        } else {
            wakings = wakings + 1
        }
    }
    Fmt.print("Wakings over $,d repetitions = $,d", reps, wakings)
    return heads/wakings * 100
}

var pc = sleepingBeauty.call(1e6)
Fmt.print("Percentage probability of heads on waking = $f\%", pc)
