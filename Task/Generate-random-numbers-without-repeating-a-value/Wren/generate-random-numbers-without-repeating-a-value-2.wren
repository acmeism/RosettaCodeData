import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()
var numbers = (1..20).toList
for (i in 1..5) {
    rand.shuffle(numbers)
    Fmt.print("$2d", numbers)
}
