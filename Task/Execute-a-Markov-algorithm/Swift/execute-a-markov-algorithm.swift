import Foundation

func setup(ruleset: String) -> [(String, String, Bool)] {
    return ruleset.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        .filter { $0.rangeOfString("^s*#", options: .RegularExpressionSearch) == nil }
        .reduce([(String, String, Bool)]()) { rules, line in
            let regex = try! NSRegularExpression(pattern: "^(.+)\\s+->\\s+(\\.?)(.*)$", options: .CaseInsensitive)
            guard let match = regex.firstMatchInString(line, options: .Anchored, range: NSMakeRange(0, line.characters.count)) else { return rules }
            return rules + [(
                (line as NSString).substringWithRange(match.rangeAtIndex(1)),
                (line as NSString).substringWithRange(match.rangeAtIndex(3)),
                (line as NSString).substringWithRange(match.rangeAtIndex(2)) != ""
            )]
        }
}

func markov(ruleset: String, var input: String) -> String {
    let rules = setup(ruleset)
    var terminate = false
    while !terminate {
        guard let i = rules.indexOf ({
            if let range = input.rangeOfString($0.0) {
                input.replaceRange(range, with: $0.1)
                return true
            }
            return false
        }) else { break }
        terminate = rules[i].2
    }
    return input
}


let tests: [(ruleset: String, input: String)] = [
    ("# This rules file is extracted from Wikipedia:\n# http://en.wikipedia.org/wiki/Markov_Algorithm\nA -> apple\nB -> bag\nS -> shop\nT -> the\nthe shop -> my brother\na never used -> .terminating rule", "I bought a B of As from T S."),
    ("# Slightly modified from the rules on Wikipedia\nA -> apple\nB -> bag\nS -> .shop\nT -> the\nthe shop -> my brother\na never used -> .terminating rule", "I bought a B of As from T S."),
    ("# BNF Syntax testing rules\nA -> apple\nWWWW -> with\nBgage -> ->.*\nB -> bag\n->.* -> money\nW -> WW\nS -> .shop\nT -> the\nthe shop -> my brother\na never used -> .terminating rule", "I bought a B of As W my Bgage from T S."),
    ("### Unary Multiplication Engine, for testing Markov Algorithm implementations\n### By Donal Fellows.\n# Unary addition engine\n_+1 -> _1+\n1+1 -> 11+\n# Pass for converting from the splitting of multiplication into ordinary\n# addition\n1! -> !1\n,! -> !+\n_! -> _\n# Unary multiplication by duplicating left side, right side times\n1*1 -> x,@y\n1x -> xX\nX, -> 1,1\nX1 -> 1X\n_x -> _X\n,x -> ,X\ny1 -> 1y\ny_ -> _\n# Next phase of applying\n1@1 -> x,@y\n1@_ -> @_\n,@_ -> !_\n++ -> +\n# Termination cleanup for addition\n_1 -> 1\n1+_ -> 1\n_+_ ->", "_1111*11111_"),
    ("# Turing machine: three-state busy beaver\n#\n# state A, symbol 0 => write 1, move right, new state B\nA0 -> 1B\n# state A, symbol 1 => write 1, move left, new state C\n0A1 -> C01\n1A1 -> C11\n# state B, symbol 0 => write 1, move left, new state A\n0B0 -> A01\n1B0 -> A11\n# state B, symbol 1 => write 1, move right, new state B\nB1 -> 1B\n# state C, symbol 0 => write 1, move left, new state B\n0C0 -> B01\n1C0 -> B11\n# state C, symbol 1 => write 1, move left, halt\n0C1 -> H01\n1C1 -> H11", "000000A000000")
]

for (index, test) in tests.enumerate() {
    print("\(index + 1):", markov(test.ruleset, input: test.input))
}
