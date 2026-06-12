import "random" for Random
import "./fmt" for Fmt

var rand = Random.new()

// Generates and prints all numbers within an inclusive range whose endpoints are 32 bit integers.
// The numbers are generated in random order with any repetitions being ignored.
var generate = Fn.new { |r|
    var generated = List.filled(r.to - r.from + 1, false) // zero indexing
    while (generated.any { |g| !g }) {
        var n = rand.int(r.from, r.to + 1) // upper endpoint is exclusive
        if (!generated[n - r.from]) {
            generated[n - r.from] = true
            Fmt.write("$2d ", n)
        }
    }
    System.print()
}

// generate 5 sets say
for (i in 1..5) generate.call(1..20)
