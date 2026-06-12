import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()
var digits = List.filled(1000, 0)
for (i in 0...999) digits[i] = rand.int(10)
var number = digits.join()
for (r in [99999..0, 0..99999]) {
    var target = (r.from == 0) ? "smallest" : "largest "
    for (i in r) {
        var quintet = Fmt.swrite("$05d", i)
        if (number.contains(quintet)) {
            Fmt.print("The $s number formed from 5 adjacent digits ($s) is: $,6d", target, quintet, i)
            break
        }
    }
}
