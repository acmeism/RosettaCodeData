import "./str" for Char, Greek

var English2Greek = Fn.new { |text|
    // make appropriate substitutions using rarely used control characters
    // for Greek letters which have no single English letter equivalents
    var subs = [
        ["v", "b"],
        ["j", "i"],
        ["y", "u"],
        ["ch", "\x01"], // chi (l/c)
        ["kh", "\x01"], // chi (l/c)
        ["ph", "f"],
        ["rh", "r"],
        ["th", "\x02"], // theta (l/c)
        ["Ch", "\x04"], // chi (u/c)
        ["Kh", "\x04"], // chi (u/c)
        ["Ph", "F"],
        ["Rh", "R"],
        ["Th", "\x05"], // theta (u/c)
        ["ee", "h"],
        ["ck", "q"],
        ["c", "q"],
        ["k", "q"],
        ["oo", "w"],
        ["ps", "\x03"], // psi(l/c)
        ["Ps", "\x06"], // psi(u/c)
        ["V", "B"],
        ["J", "I"],
        ["Y", "U"],
        ["CH", "\x04"], // chi (u/c)
        ["KH", "\x04"], // chi (u/c)
        ["PH", "F"],
        ["RH", "R"],
        ["TH", "\x05"], // theta (u/c)
        ["EE", "H"],
        ["CK", "Q"],
        ["C", "Q"],
        ["K", "Q"],
        ["OO", "W"],
        ["PS", "\x06"], // psi(u/c)
    ]
    for (sub in subs) text = text.replace(sub[0], sub[1])

    // now look for final English lower case 's' and use 'DEL' to substitute for that
    var letters = text.toList
    for (i in 1...letters.count) {
        var c = letters[i]
        if ((Char.isWhitespace(c) || Char.isPunctuation(c)) && letters[i-1] == "s") {
            letters[i-1] = "\x7f"
        }
    }

    // finally substitute the remaining English 'letters' with Greek ones
    // note that some of them look the same but are different codepoints
    var e2g = {
        "a": "α", "b": "β", "d": "δ", "e": "ε", "f": "φ", "g": "γ", "h": "η",
        "i": "ι", "l": "λ", "m": "μ", "n": "ν", "o": "ο", "p": "π", "q": "κ",
        "r": "ρ", "s": "σ", "t": "τ", "u": "υ", "w": "ω", "x": "ξ", "z": "ζ",
        "A": "Α", "B": "Β", "D": "Δ", "E": "Ε", "F": "Φ", "G": "Γ", "H": "Η",
        "I": "Ι", "L": "Λ", "M": "Μ", "N": "Ν", "O": "Ο", "P": "Π", "Q": "Κ",
        "R": "Ρ", "S": "Σ", "T": "Τ", "U": "Υ", "W": "Ω", "X": "Ξ", "Z": "Ζ",
        "\x01": "χ", "\x02": "θ", "\x03": "ψ", "\x7f": "ς",
        "\x04": "Χ", "\x05": "Θ", "\x06": "Ψ"
    }

    var greek = List.filled(letters.count, null)
    for (i in 0...greek.count) {
        var c = letters[i]
        if (Char.isWhitespace(c) || Char.isPunctuation(c)) {
            greek[i] = c
        } else {
            greek[i] = e2g[letters[i]]
        }
    }
    return greek.join("")
}

var texts = [
"The quick brown fox jumped over the lazy dog.",
"""
I was looking at some rhododendrons in my back garden,
dressed in my khaki shorts, when the telephone rang.

As I answered it, I cheerfully glimpsed that the July sun
caused a fragment of black pine wax to ooze on the velvet quilt
laying in my patio.
""",
"sphinx of black quartz, judge my vow."
]
for (text in texts) {
    System.print(text)
    System.print()
    System.print(English2Greek.call(text))
    System.print("=" * 65)
}
System.print("The last example using the names of the Greek letters instead:")
var greek = English2Greek.call(texts[2])
var s = ""
for (g in greek) {
    var c
    if (Char.isWhitespace(g) || Char.isPunctuation(g)) {
        c = g
    } else {
        c = "<" + Greek.name(g) + ">"
    }
    s = s + c
}
System.print(s)
