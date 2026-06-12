import "./fmt" for Conv, Fmt
import "./iterate" for Stepped
import "./str" for Char
import "./seq" for Lst

var src         = ""
var ch          = ""
var sdx         = 0
var token       = null
var isSeq       = false
var err         = false
var idents      = []
var ididx       = []
var productions = []
var extras      = []
var results     = ["pass", "fail"]

var invalid = Fn.new { |msg|
    err = true
    System.print(msg)
    sdx = src.count // set to EOF
    return -1
}

var skipSpaces = Fn.new {
    while (true) {
        if (sdx >= src.count) return
        ch = src[sdx]
        if (!" \t\r\n".contains(ch)) return
        sdx = sdx + 1
    }
}

var getToken = Fn.new {
    // Yields a single character token, one of {}()[]|=.;
    // or {"terminal",string} or {"ident", string} or -1.
    skipSpaces.call()
    if (sdx >= src.count) {
        token = -1
        isSeq = false
        return
    }
    var tokstart = sdx
    if ("{}()[]|=.;".contains(ch)) {
        sdx = sdx + 1
        token = ch
        isSeq = false
    } else if (ch == "\"" || ch == "'") {
        var closech = ch
        for (tokend in Stepped.ascend(sdx + 1...src.count)) {
            if (src[tokend] == closech) {
                sdx = tokend + 1
                token = ["terminal", src[tokstart+1...tokend]]
                isSeq = true
                return
            }
        }
        token = invalid.call("no closing quote")
        isSeq = false
    } else if (Char.isAsciiLower(ch)) {
        // To simplify things for the purposes of this task,
        // identifiers are strictly a-z only, not A-Z or 1-9.
        while (true) {
            sdx = sdx + 1
            if (sdx >= src.count) break
            ch = src[sdx]
            if (!Char.isAsciiLower(ch)) break
        }
        token = ["ident", src[tokstart...sdx]]
        isSeq = true
    } else {
        token = invalid.call("invalid ebnf")
        isSeq = false
    }
}

var matchToken = Fn.new { |ch|
    if (token != ch) {
        token = invalid.call("invalid ebnf (%(ch) expected)")
        isSeq = false
    } else {
        getToken.call()
    }
}

var addIdent = Fn.new { |ident|
    var k = -1
    var i = 0
    for (id in idents) {
        if (id == ident) {
            k = i
            break
        }
        i =  i + 1
    }
    if (k == -1) {
        idents.add(ident)
        k = idents.count - 1
        ididx.add(-1)
    }
    return k
}

var expression // forward declaration

var factor = Fn.new {
    var res
    if (isSeq) {
        if (token[0] == "ident") {
            var idx = addIdent.call(token[1])
            token.add(idx)
        }
        res = token
        getToken.call()
    } else if (token == "[") {
        getToken.call()
        res = ["optional", expression.call()]
        matchToken.call("]")
    } else if (token == "(") {
        getToken.call()
        res = expression.call()
        matchToken.call(")")
    } else if (token == "{") {
        getToken.call()
        res = ["repeat", expression.call()]
        matchToken.call("}")
    } else {
        Fiber.abort("invalid token in factor() function")
    }
    if (res is Sequence && res.count == 1) return res[0]
    return res
}

var term = Fn.new {
    var res = [factor.call()]
    var tokens = [-1, "|", ".", ";", ")", "]", "}"]
    while (true) {
        var outer = false
        for (t in tokens) {
            if (t == token) {
                outer = true
                break
            }
        }
        if (outer) break
        res.add(factor.call())
    }
    if (res.count == 1) return res[0]
    return res
}

// declared earlier
expression = Fn.new {
    var res = [term.call()]
    if (token == "|") {
        res = ["or", res[0]]
        while (token == "|") {
            getToken.call()
            res.add(term.call())
        }
    }
    if (res.count == 1) return res[0]
    return res
}

var production = Fn.new {
    // Returns a token or -1; the real result is left in 'productions' etc,
    getToken.call()
    if (token != "}") {
        if (token == -1) return invalid.call("invalid ebnf (missing closing })")
        if (!isSeq) return -1
        if (token[0] != "ident") return -1
        var ident = token[1]
        var idx = addIdent.call(ident)
        getToken.call()
        matchToken.call("=")
        if (token == -1) return -1
        productions.add([ident, idx, expression.call()])
        ididx[idx] = productions.count - 1
    }
    return token
}

// Adjusts Wren's normal printing of lists to look more like Phix output.
var pprint = Fn.new { |ob, header|
    Fmt.print("\n$s:", header)
    var quote // recursive closure
    quote = Fn.new { |list|
        for (i in 0...list.count) {
            if (list[i] is String) {
                list[i] = Fmt.swrite("$q", list[i])
            } else if (list[i] is List) quote.call(list[i])
         }
    }
    var obs
    if (ob is String) {
        obs = Fmt.swrite("$q", ob)
    } else if (ob is List) {
        obs = Lst.clone(ob)
        quote.call(obs)
    }
    var pp = obs.toString
    pp = pp.replace("[", "{")
    pp = pp.replace("]", "}")
    for (i in 0...idents.count) {
        var xs = Fmt.swrite("'\\x$02d'", i)
        pp = pp.replace(xs, i.toString)
    }
    System.print(pp)
}

var parse = Fn.new { |ebnf|
    // Returns +1 if ok, -1 if bad.
    System.print("parse:\n%(ebnf) ===>")
    err = false
    src = ebnf
    sdx = 0
    idents.clear()
    ididx.clear()
    productions.clear()
    extras.clear()
    getToken.call()
    if (isSeq) {
        token[0] = "title"
        extras.add(token)
        getToken.call()
    }
    if (token != "{") return invalid.call("invalid ebnf (missing opening {)")
    while (true) {
        token = production.call()
        if (token == "}" || token == -1) break
    }
    getToken.call()
    if (isSeq) {
        token[0] = "comment"
        extras.add(token)
        getToken.call()
    }
    if (token != -1) return invalid.call("invalid ebnf (missing eof?)")
    if (err) return -1
    var k = -1
    var i = 0
    for (idx in ididx) {
        if (idx == -1) {
            k = i
            break
        }
        i = i + 1
    }
    if (k != -1) return invalid.call("invalid ebnf (undefined:%(idents[k]))")
    pprint.call(productions, "productions")
    pprint.call(idents, "idents")
    pprint.call(ididx, "ididx")
    pprint.call(extras, "extras")
    return 1
}

// The rules that applies() has to deal with are:
// {factors} - if rule[0] is not string,
// just apply one after the other recursively.
// {"terminal", "a1"}       -- literal constants
// {"or", <e1>, <e2>, ...}  -- (any) one of n
// {"repeat", <e1>}         -- as per "{}" in ebnf
// {"optional", <e1>}       -- as per "[]" in ebnf
// {"ident", <name>, idx}   -- apply the sub-rule
var applies // recursive function
applies = Fn.new { |rule|
    var wasSdx = sdx // in case of failure
    var r1 = rule[0]
    if (!(r1 is String)) {
        for (i in 0...rule.count) {
            if (!applies.call(rule[i])) {
                sdx = wasSdx
                return false
            }
        }
    } else if (r1 == "terminal") {
        skipSpaces.call()
        var r2 = rule[1]
        for (i in 0...r2.count) {
            if (sdx >= src.count || src[sdx] != r2[i]) {
                sdx = wasSdx
                return false
            }
            sdx = sdx + 1
        }
    } else if (r1 == "or") {
        for (i in Stepped.ascend(1...rule.count)) {
            if (applies.call(rule[i])) return true
        }
        sdx = wasSdx
        return false
    } else if (r1 == "repeat") {
        while (applies.call(rule[1])) {}
    } else if (r1 == "optional") {
        applies.call(rule[1])
    } else if (r1 == "ident") {
        var i = rule[2]
        var ii = ididx[i]
        if (!(applies.call(productions[ii][2]))) {
            sdx = wasSdx
            return false
        }
    } else {
        Fiber.abort("invalid rule in applies() function")
    }
    return true
}

var checkValid = Fn.new { |test|
    src = test
    sdx = 0
    var res = applies.call(productions[0][2])
    skipSpaces.call()
    if (sdx < src.count) res = false
    Fmt.print("$q, $s", test, results[1-Conv.btoi(res)])
}

var ebnfs = [
    """"a" {
    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
} "z" """,
    """{
    expr = term { plus term } .
    term = factor { times factor } .
    factor = number | '(' expr ')' .

    plus = "+" | "-" .
    times = "*" | "/" .

    number = digit { digit } .
    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
}""",
    "a = \"1\"",
    """{ a = "1" ;""",
    """{ hello world = "1"; }""",
    """{ foo = bar . }"""
]

var tests = [
    [
        "a1a3a4a4a5a6",
        "a1 a2a6",
        "a1 a3 a4 a6",
        "a1 a4 a5 a6",
        "a1 a2 a4 a5 a5 a6",
        "a1 a2 a4 a5 a6 a7",
        "your ad here"
    ],
    [
        "2",
        "2*3 + 4/23 - 7",
        "(3 + 4) * 6-2+(4*(4))",
        "-2",
        "3 +",
        "(4 + 3"
    ]
]

var i = 0
for (ebnf in ebnfs) {
    if (parse.call(ebnf) == 1) {
        System.print("\ntests:")
        for (test in tests[i]) checkValid.call(test)
    }
    System.print()
    i = i + 1
}
