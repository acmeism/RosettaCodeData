import "/pattern" for Pattern
import "/str" for Str
import "/fmt" for Fmt
import "/sort" for Cmp, Sort

var p2 = Pattern.new("+2 ")
var p3 = Pattern.new("/s") // any whitespace character
var p5 = Pattern.new("+1/d")

/** Only covers ISO-8859-1 accented characters plus (for consistency) Ÿ */
var ucAccented = ["ÀÁÂÃÄÅ", "Ç", "ÈÉÊË", "ÌÍÎÏ", "Ñ", "ÒÓÔÕÖØ", "ÙÚÛÜ", "ÝŸ"]
var lcAccented = ["àáâãäå", "ç", "èéêë", "ìíîï", "ñ", "òóôõöø", "ùúûü", "ýÿ"]
var ucNormal   = "ACEINOUY"
var lcNormal   = "aceinouy"

/** Only the commoner ligatures */
var ucLigatures = "ÆĲŒ"
var lcLigatures = "æĳœ"
var ucSeparated = ["AE", "IJ", "OE"]
var lcSeparated = ["ae", "ij", "oe"]

/** Miscellaneous replacements */
var miscLetters = "ßſʒ"
var miscReplacements = ["ss", "s", "s"]

/** Displays strings including whitespace as if the latter were literal characters */
var toDisplayString = Fn.new { |s|
    var whitespace  = ["\t", "\n", "\v", "\f", "\r"]
    var whitespace2 = ["\\t", "\\n", "\\v", "\\f", "\\r"]
    for (i in 0..4) s = s.replace(whitespace[i], whitespace2[i])
    return s
}

/** Ignoring leading space(s) */
var selector1 = Fn.new { |s| s.trimStart(" ") }

/** Ignoring multiple adjacent spaces i.e. condensing to a single space */
var selector2 = Fn.new { |s| p2.replaceAll(s, " ") }

/** Equivalent whitespace characters (equivalent to a space say) */
var selector3 = Fn.new { |s| p3.replaceAll(s, " ") }

/** Case independent sort */
var selector4 = Fn.new { |s| Str.lower(s) }

/** Numeric fields as numerics (deals with up to 20 digits) */
var selector5 = Fn.new { |s|
    for (m in p5.findAll(s)) {
        var ix = m.index
        var repl = Fmt.swrite("$020d", Num.fromString(m.text))
        s = s[0...ix] + repl + s[ix + m.length..-1]
    }
    return s
}

/** Title sort */
var selector6 = Fn.new { |s|
    var t = Str.lower(s)
    if (t.startsWith("the ")) return s.skip(4).join()
    if (t.startsWith("an ")) return s.skip(3).join()
    if (t.startsWith("a ")) return s.skip(2).join()
    return s
}

/** Equivalent accented characters (and case) */
var selector7 = Fn.new { |s|
    var sb = ""
    for (c in s) {
        var outer = false
        var i = 0
        for (ucs in ucAccented) {
            if (ucs.contains(c)) {
                sb = sb + ucNormal[i]
                outer = true
                break
            }
            i = i + 1
        }
        if (outer) continue
        i = 0
        for (lcs in lcAccented) {
            if (lcs.contains(c)) {
                sb = sb + lcNormal[i]
                outer = true
                break
            }
            i = i + 1
        }
        if (outer) continue
        sb = sb + c
    }
    return Str.lower(sb)
}

/** Separated ligatures */
var selector8 = Fn.new { |s|
    var i = 0
    for (c in ucLigatures) {
        s = s.replace(c, ucSeparated[i])
        i = i + 1
    }
    i = 0
    for (c in lcLigatures) {
        s = s.replace(c, lcSeparated[i])
        i = i + 1
    }
    return s
}

/** Character replacements */
var selector9 = Fn.new { |s|
    var i = 0
    for (c in miscLetters) {
        s = s.replace(c, miscReplacements[i])
        i = i + 1
    }
    return s
}

System.print("The 9 string lists, sorted 'naturally':\n")
var selectors = [selector1, selector2, selector3, selector4, selector5,
                 selector6, selector7, selector8, selector9]
var ss = [
    [
        "ignore leading spaces: 2-2",
        " ignore leading spaces: 2-1",
        "  ignore leading spaces: 2+0",
        "   ignore leading spaces: 2+1"
    ],
    [
        "ignore m.a.s spaces: 2-2",
        "ignore m.a.s  spaces: 2-1",
        "ignore m.a.s   spaces: 2+0",
        "ignore m.a.s    spaces: 2+1"
    ],
    [
        "Equiv. spaces: 3-3",
        "Equiv.\rspaces: 3-2",
        "Equiv.\vspaces: 3-1",
        "Equiv.\fspaces: 3+0",
        "Equiv.\nspaces: 3+1",
        "Equiv.\tspaces: 3+2"
    ],
    [
        "cASE INDEPENENT: 3-2",
        "caSE INDEPENENT: 3-1",
        "casE INDEPENENT: 3+0",
        "case INDEPENENT: 3+1"
    ],
    [
        "foo100bar99baz0.txt",
        "foo100bar10baz0.txt",
        "foo1000bar99baz10.txt",
        "foo1000bar99baz9.txt"
    ],
    [
        "The Wind in the Willows",
        "The 40th step more",
        "The 39 steps",
        "Wanda"
    ],
    [
        "Equiv. ý accents: 2-2",
        "Equiv. Ý accents: 2-1",
        "Equiv. y accents: 2+0",
        "Equiv. Y accents: 2+1"
    ],
    [
        "Ĳ ligatured ij",
        "no ligature"
    ],
    [
        "Start with an ʒ: 2-2",
        "Start with an ſ: 2-1",
        "Start with an ß: 2+0",
        "Start with an s: 2+1"
    ]
]
for (i in 0..8) {
    var sel = selectors[i]
    var cmp = Fn.new { |s1, s2| Cmp.string.call(sel.call(s1), sel.call(s2)) }
    Sort.insertion(ss[i], cmp)
    System.print(ss[i].map { |s| "'%(s)'" }.join("\n"))
    if (i < 8) System.print()
}
