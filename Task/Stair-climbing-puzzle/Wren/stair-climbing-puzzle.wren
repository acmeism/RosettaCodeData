import "random" for Random
import "./fmt" for Conv

var rand = Random.new(1268) // generates short repeatable sequence
var position = 0

var step = Fn.new {
    var r = Conv.itob(rand.int(2))
    if (r) {
        position = position + 1
        System.print("Climbed up to %(position)")
    } else {
        position = position - 1
        System.print("Fell down to %(position)")
    }
    return r
}

var stepUp // recursive
stepUp = Fn.new {
    while (!step.call()) stepUp.call()
}

stepUp.call()
