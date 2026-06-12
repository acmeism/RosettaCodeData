import "./set" for Set

// Function to perform the CYK Algorithm.
var cykParse = Fn.new { |w, r, s|
    var n = w.count

    // Initialize the table with empty sets.
    var t = List.filled(n, null)
    for (i in 0...n) {
        t[i] = List.filled(n, null)
        for (j in 0...n) t[i][j] = Set.new()
    }

    // Filling in the table.
    for (j in 0...n) {
        // Iterate over the rules.
        for (me in r) {
            var lhs = me.key
            var rules = me.value
            for (rhs in rules) {
                // If a terminal is found.
                if (rhs.count == 1 && rhs[0] == w[j]) {
                    t[j][j].add(lhs)
                }
            }
        }

        for (i in j..0) {
            // Iterate over the range i to j.
            for (k in i...j) {
                // Iterate over the rules.
                for (me in r) {
                    var lhs = me.key
                    var rules = me.value
                    for (rhs in rules) {
                        // If a non-terminal pair is found.
                        if (rhs.count == 2 && t[i][k].contains(rhs[0]) &&
                            t[k + 1][j].contains(rhs[1])) {
                            t[i][j].add(lhs)
                        }
                    }
                }
            }
        }
    }
    // If word can be formed by rules of given grammar.
    if (t[0][n - 1].contains(s)) {
        System.print("True")
    } else {
        System.print("False")
    }
}

// Rules of the grammar.
var r = {}
r["NP"]  = [ ["Det", "Nom"] ]
r["Nom"] = [ ["AP", "Nom"], ["book"], ["orange"], ["man"] ]
r["AP"]  = [ ["Adv", "A"], ["heavy"], ["orange"], ["tall"] ]
r["Det"] = [ ["a"] ]
r["Adv"] = [ ["very"], ["extremely"] ]
r["A"]   = [ ["heavy"], ["orange"], ["tall"], ["muscular"] ]

// Given string.
var tests = [
    "a very heavy orange book",
    "a very heavy orange",
    "a heavy orange",
    "a heavy",
    "orange",
    "very heavy orange"
]

// Starting symbol.
var s = "NP"

for (test in tests) {
    var w = test.split(" ")
    cykParse.call(w, r, s)
}
