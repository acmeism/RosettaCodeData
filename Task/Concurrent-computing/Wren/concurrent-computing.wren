import "random" for Random

var words = ["Enjoy", "Rosetta", "Code"]
var rand = Random.new()
for (h in 1..3) {
    var fibers = List.filled(3, null)
    for (i in 0..2) fibers[i] = Fiber.new { System.print(words[i]) }
    var called = List.filled(3, false)
    var j = 0
    while (j < 3) {
        var k = rand.int(3)
        if (!called[k]) {
            fibers[k].call()
            called[k] = true
            j = j + 1
        }
    }
    System.print()
}
