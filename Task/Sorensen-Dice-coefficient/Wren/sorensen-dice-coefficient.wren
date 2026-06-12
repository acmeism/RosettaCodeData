import "io" for File
import "./str" for Str
import "./set" for Bag
import "./fmt" for Fmt

var bigrams = Fn.new { |phrase|
    var words = Str.splitNoEmpty(phrase, " ")
    var res = []
    for (word in words) {
        var chars = Str.lower(word).toList
        if (chars.count == 1) {
            res.add(chars[0])
        } else {
            for (i in 0...chars.count-1) {
                res.add(chars[i] + chars[i+1])
            }
        }
    }
    return res
}

var sorensen = Fn.new { |a, b|
    var abi = Bag.new(bigrams.call(a))
    var bbi = Bag.new(bigrams.call(b))
    var common = abi.intersect(bbi)
    return 2 * common.count / (abi.count + bbi.count)
}

var fileName = "rc_tasks_2022_09_24.txt"  // local copy
var tasks = File.read(fileName).trimEnd().split("\n")
var tc = tasks.count
var tests = [
    "Primordial primes", "Sunkist-Giuliani formula", "Sieve of Euripides", "Chowder numbers"
]
var sdis = List.filled(tc, null)
for (test in tests) {
    for (i in 0...tasks.count) sdis[i] = [tasks[i], sorensen.call(tasks[i], test)]
    var top5 = sdis.sort { |e1, e2| e1[1] >= e2[1] }.take(5).toList
    System.print("%(test) >")
    for (e in top5) Fmt.print("  $f $s", e[1], e[0])
    System.print()
}
