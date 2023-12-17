import "random" for Random
import "./fmt" for Fmt
import "./sort" for Sort

var rand = Random.new()
var bases = "ACGT"

// 'w' contains the weights out of 300 for each
// of swap, delete or insert in that order.
var mutate = Fn.new { |dna, w|
    var le = dna.count
    // get a random position in the dna to mutate
    var p = rand.int(le)
    // get a random number between 0 and 299 inclusive
    var r = rand.int(300)
    var chars = dna.toList
    if (r < w[0]) {   // swap
        var base = bases[rand.int(4)]
        Fmt.print("  Change @$3d $q to $q", p, chars[p], base)
        chars[p] = base
    } else if (r < w[0] + w[1]) {  // delete
        Fmt.print("  Delete @$3d $q", p, chars[p])
        chars.removeAt(p)
    } else { // insert
        var base = bases[rand.int(4)]
        Fmt.print("  Insert @$3d $q", p, base)
        chars.insert(p, base)
    }
    return chars.join()
}

// Generate a random dna sequence of given length.
var generate = Fn.new { |le|
    var chars = [""] * le
    for (i in 0...le) chars[i] = bases[rand.int(4)]
    return chars.join()
}

// Pretty print dna and stats.
var prettyPrint = Fn.new { |dna, rowLen|
    System.print("SEQUENCE:")
    var le = dna.count
    var i = 0
    while (i < le) {
        var k = i + rowLen
        if (k > le) k = le
        Fmt.print("$5d: $s", i, dna[i...k])
        i =  i + rowLen
    }
    var baseMap = {}
    for (i in 0...le) {
        var v = baseMap[dna[i]]
        baseMap[dna[i]] = (v) ? v + 1 : 1
    }
    var bases = []
    for (k in baseMap.keys) bases.add(k)
    Sort.insertion(bases) // get bases into alphabetic order
    System.print("\nBASE COUNT:")
    for (base in bases) Fmt.print("    $s: $3d", base, baseMap[base])
    System.print("    ------")
    System.print("    Σ: %(le)")
    System.print("    ======\n")
}

// Express weights as a string.
var wstring = Fn.new { |w|
    return Fmt.swrite("  Change: $d\n  Delete: $d\n  Insert: $d\n", w[0], w[1], w[2])
}

var dna = generate.call(250)
prettyPrint.call(dna, 50)
var muts = 10
var w = [100, 100, 100] // use e.g. {0, 300, 0} to choose only deletions
Fmt.print("WEIGHTS (ex 300):\n$s", wstring.call(w))
Fmt.print("MUTATIONS ($d):", muts)
for (i in 0...muts) dna = mutate.call(dna, w)
System.print()
prettyPrint.call(dna, 50)
