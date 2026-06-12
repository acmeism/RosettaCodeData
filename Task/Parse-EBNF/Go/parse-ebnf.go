package main

import (
    "fmt"
    "strings"
)

// type aliases for Phix types
type object = interface{}
type sequence = []object

var (
    src         []rune
    ch          rune
    sdx         int
    token       object
    isSeq       bool
    err         = false
    idents      []string
    ididx       []int
    productions []sequence
    extras      sequence
    results     = [2]string{"pass", "fail"}
)

func btoi(b bool) int {
    if b {
        return 1
    }
    return 0
}

func invalid(msg string) int {
    err = true
    fmt.Println(msg)
    sdx = len(src) // set to eof
    return -1
}

func skipSpaces() {
    for {
        if sdx >= len(src) {
            break
        }
        ch = src[sdx]
        if strings.IndexRune(" \t\r\n", ch) == -1 {
            break
        }
        sdx++
    }
}

func getToken() {
    // Yields a single character token, one of {}()[]|=.;
    // or {"terminal",string} or {"ident", string} or -1.
    skipSpaces()
    if sdx >= len(src) {
        token = -1
        isSeq = false
        return
    }
    tokstart := sdx
    if strings.IndexRune("{}()[]|=.;", ch) >= 0 {
        sdx++
        token = ch
        isSeq = false
    } else if ch == '"' || ch == '\'' {
        closech := ch
        for tokend := sdx + 1; tokend < len(src); tokend++ {
            if src[tokend] == closech {
                sdx = tokend + 1
                token = sequence{"terminal", string(src[tokstart+1 : tokend])}
                isSeq = true
                return
            }
        }
        token = invalid("no closing quote")
        isSeq = false
    } else if ch >= 'a' && ch <= 'z' {
        // To simplify things for the purposes of this task,
        // identifiers are strictly a-z only, not A-Z or 1-9.
        for {
            sdx++
            if sdx >= len(src) {
                break
            }
            ch = src[sdx]
            if ch < 'a' || ch > 'z' {
                break
            }
        }
        token = sequence{"ident", string(src[tokstart:sdx])}
        isSeq = true
    } else {
        token = invalid("invalid ebnf")
        isSeq = false
    }
}

func matchToken(ch rune) {
    if token != ch {
        token = invalid(fmt.Sprintf("invalid ebnf (%c expected)", ch))
        isSeq = false
    } else {
        getToken()
    }
}

func addIdent(ident string) int {
    k := -1
    for i, id := range idents {
        if id == ident {
            k = i
            break
        }
    }
    if k == -1 {
        idents = append(idents, ident)
        k = len(idents) - 1
        ididx = append(ididx, -1)
    }
    return k
}

func factor() object {
    var res object
    if isSeq {
        t := token.([]object)
        if t[0] == "ident" {
            idx := addIdent(t[1].(string))
            t = append(t, idx)
            token = t
        }
        res = token
        getToken()
    } else if token == '[' {
        getToken()
        res = sequence{"optional", expression()}
        matchToken(']')
    } else if token == '(' {
        getToken()
        res = expression()
        matchToken(')')
    } else if token == '{' {
        getToken()
        res = sequence{"repeat", expression()}
        matchToken('}')
    } else {
        panic("invalid token in factor() function")
    }
    if s, ok := res.(sequence); ok && len(s) == 1 {
        return s[0]
    }
    return res
}

func term() object {
    res := sequence{factor()}
    tokens := []object{-1, '|', '.', ';', ')', ']', '}'}
outer:
    for {
        for _, t := range tokens {
            if t == token {
                break outer
            }
        }
        res = append(res, factor())
    }
    if len(res) == 1 {
        return res[0]
    }
    return res
}

func expression() object {
    res := sequence{term()}
    if token == '|' {
        res = sequence{"or", res[0]}
        for token == '|' {
            getToken()
            res = append(res, term())
        }
    }
    if len(res) == 1 {
        return res[0]
    }
    return res
}

func production() object {
    // Returns a token or -1; the real result is left in 'productions' etc,
    getToken()
    if token != '}' {
        if token == -1 {
            return invalid("invalid ebnf (missing closing })")
        }
        if !isSeq {
            return -1
        }
        t := token.(sequence)
        if t[0] != "ident" {
            return -1
        }
        ident := t[1].(string)
        idx := addIdent(ident)
        getToken()
        matchToken('=')
        if token == -1 {
            return -1
        }
        productions = append(productions, sequence{ident, idx, expression()})
        ididx[idx] = len(productions) - 1
    }
    return token
}

func parse(ebnf string) int {
    // Returns +1 if ok, -1 if bad.
    fmt.Printf("parse:\n%s ===>\n", ebnf)
    err = false
    src = []rune(ebnf)
    sdx = 0
    idents = idents[:0]
    ididx = ididx[:0]
    productions = productions[:0]
    extras = extras[:0]
    getToken()
    if isSeq {
        t := token.(sequence)
        t[0] = "title"
        extras = append(extras, token)
        getToken()
    }
    if token != '{' {
        return invalid("invalid ebnf (missing opening {)")
    }
    for {
        token = production()
        if token == '}' || token == -1 {
            break
        }
    }
    getToken()
    if isSeq {
        t := token.(sequence)
        t[0] = "comment"
        extras = append(extras, token)
        getToken()
    }
    if token != -1 {
        return invalid("invalid ebnf (missing eof?)")
    }
    if err {
        return -1
    }
    k := -1
    for i, idx := range ididx {
        if idx == -1 {
            k = i
            break
        }
    }
    if k != -1 {
        return invalid(fmt.Sprintf("invalid ebnf (undefined:%s)", idents[k]))
    }
    pprint(productions, "productions")
    pprint(idents, "idents")
    pprint(ididx, "ididx")
    pprint(extras, "extras")
    return 1
}

// Adjusts Go's normal printing of slices to look more like Phix output.
func pprint(ob object, header string) {
    fmt.Printf("\n%s:\n", header)
    pp := fmt.Sprintf("%q", ob)
    pp = strings.Replace(pp, "[", "{", -1)
    pp = strings.Replace(pp, "]", "}", -1)
    pp = strings.Replace(pp, " ", ", ", -1)
    for i := 0; i < len(idents); i++ {
        xs := fmt.Sprintf(`'\x%02d'`, i)
        is := fmt.Sprintf("%d", i)
        pp = strings.Replace(pp, xs, is, -1)
    }
    fmt.Println(pp)
}

// The rules that applies() has to deal with are:
// {factors} - if rule[0] is not string,
// just apply one after the other recursively.
// {"terminal", "a1"}       -- literal constants
// {"or", <e1>, <e2>, ...}  -- (any) one of n
// {"repeat", <e1>}         -- as per "{}" in ebnf
// {"optional", <e1>}       -- as per "[]" in ebnf
// {"ident", <name>, idx}   -- apply the sub-rule

func applies(rule sequence) bool {
    wasSdx := sdx // in case of failure
    r1 := rule[0]
    if _, ok := r1.(string); !ok {
        for i := 0; i < len(rule); i++ {
            if !applies(rule[i].(sequence)) {
                sdx = wasSdx
                return false
            }
        }
    } else if r1 == "terminal" {
        skipSpaces()
        r2 := []rune(rule[1].(string))
        for i := 0; i < len(r2); i++ {
            if sdx >= len(src) || src[sdx] != r2[i] {
                sdx = wasSdx
                return false
            }
            sdx++
        }
    } else if r1 == "or" {
        for i := 1; i < len(rule); i++ {
            if applies(rule[i].(sequence)) {
                return true
            }
        }
        sdx = wasSdx
        return false
    } else if r1 == "repeat" {
        for applies(rule[1].(sequence)) {
        }
    } else if r1 == "optional" {
        applies(rule[1].(sequence))
    } else if r1 == "ident" {
        i := rule[2].(int)
        ii := ididx[i]
        if !applies(productions[ii][2].(sequence)) {
            sdx = wasSdx
            return false
        }
    } else {
        panic("invalid rule in applies() function")
    }
    return true
}

func checkValid(test string) {
    src = []rune(test)
    sdx = 0
    res := applies(productions[0][2].(sequence))
    skipSpaces()
    if sdx < len(src) {
        res = false
    }
    fmt.Printf("%q, %s\n", test, results[1-btoi(res)])
}

func main() {
    ebnfs := []string{
        `"a" {
    a = "a1" ( "a2" | "a3" ) { "a4" } [ "a5" ] "a6" ;
} "z" `,
        `{
    expr = term { plus term } .
    term = factor { times factor } .
    factor = number | '(' expr ')' .

    plus = "+" | "-" .
    times = "*" | "/" .

    number = digit { digit } .
    digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" .
}`,
        `a = "1"`,
        `{ a = "1" ;`,
        `{ hello world = "1"; }`,
        `{ foo = bar . }`,
    }

    tests := [][]string{
        {
            "a1a3a4a4a5a6",
            "a1 a2a6",
            "a1 a3 a4 a6",
            "a1 a4 a5 a6",
            "a1 a2 a4 a5 a5 a6",
            "a1 a2 a4 a5 a6 a7",
            "your ad here",
        },
        {
            "2",
            "2*3 + 4/23 - 7",
            "(3 + 4) * 6-2+(4*(4))",
            "-2",
            "3 +",
            "(4 + 3",
        },
    }

    for i, ebnf := range ebnfs {
        if parse(ebnf) == +1 {
            fmt.Println("\ntests:")
            for _, test := range tests[i] {
                checkValid(test)
            }
        }
        fmt.Println()
    }
}
