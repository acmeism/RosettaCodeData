import Foundation

class EBNFParser {
    // Data structures for better organization
    private struct Token {
        let value: Any
        let isSequence: Bool

        init(_ value: Any, _ isSequence: Bool) {
            self.value = value
            self.isSequence = isSequence
        }
    }

    private class Sequence {
        private var items: [Any] = []

        init(_ items: Any...) {
            self.items = Array(items)
        }

        subscript(index: Int) -> Any {
            get { return items[index] }
            set { items[index] = newValue }
        }

        func add(_ item: Any) {
            items.append(item)
        }

        var count: Int {
            return items.count
        }

        var size: Int {
            return items.count
        }

        func contains(_ item: Any) -> Bool {
            for i in items {
                if let str1 = i as? String, let str2 = item as? String {
                    if str1 == str2 { return true }
                }
                if let int1 = i as? Int, let int2 = item as? Int {
                    if int1 == int2 { return true }
                }
                if let char1 = i as? Character, let char2 = item as? Character {
                    if char1 == char2 { return true }
                }
            }
            return false
        }

        var description: String {
            return items.map { "\($0)" }.joined(separator: ", ")
        }
    }

    private var src: String = ""
    private var ch: Character = " "
    private var sdx: Int = 0
    private var token: Token = Token(-1, false)
    private var err: Bool = false
    private var idents: [String] = []
    private var ididx: [Int] = []
    private var productions: [Sequence] = []
    private var extras = Sequence()
    private let results = ["pass", "fail"]

    private func boolToInt(_ value: Bool) -> Int {
        return value ? 1 : 0
    }

    private func invalid(_ msg: String) -> Int {
        err = true
        print(msg)
        sdx = src.count // set to eof
        return -1
    }

    private func skipSpaces() {
        while sdx < src.count {
            let index = src.index(src.startIndex, offsetBy: sdx)
            ch = src[index]
            if !(" \t\r\n".contains(ch)) {
                break
            }
            sdx += 1
        }
    }

    private func getToken() {
        // Yields a single character token, one of {}()[]|=.;
        // or {"terminal",string} or {"ident", string} or -1.
        skipSpaces()
        if sdx >= src.count {
            token = Token(-1, false)
            return
        }
        let tokstart = sdx

        if "{}()[]|=.;".contains(ch) {
            sdx += 1
            token = Token(ch, false)
        } else if ch == "\"" || ch == "'" {
            let closech = ch
            var tokend = tokstart + 1
            while tokend < src.count {
                let index = src.index(src.startIndex, offsetBy: tokend)
                if src[index] == closech {
                    break
                }
                tokend += 1
            }
            if tokend >= src.count {
                token = Token(invalid("no closing quote"), false)
            } else {
                sdx = tokend + 1
                let startIndex = src.index(src.startIndex, offsetBy: tokstart + 1)
                let endIndex = src.index(src.startIndex, offsetBy: tokend)
                let substring = String(src[startIndex..<endIndex])
                token = Token(Sequence("terminal", substring), true)
            }
        } else if ch.isLowercase && ch.isLetter {
            // To simplify things for the purposes of this task,
            // identifiers are strictly a-z only, not A-Z or 1-9.
            while sdx < src.count {
                let index = src.index(src.startIndex, offsetBy: sdx)
                ch = src[index]
                if !ch.isLowercase || !ch.isLetter {
                    break
                }
                sdx += 1
            }
            let startIndex = src.index(src.startIndex, offsetBy: tokstart)
            let endIndex = src.index(src.startIndex, offsetBy: sdx)
            let substring = String(src[startIndex..<endIndex])
            token = Token(Sequence("ident", substring), true)
        } else {
            token = Token(invalid("invalid ebnf"), false)
        }
    }

    private func matchToken(_ expectedCh: Character) {
        if let tokenChar = token.value as? Character, tokenChar != expectedCh {
            token = Token(invalid("invalid ebnf (\(expectedCh) expected)"), false)
        } else if !(token.value is Character) {
            token = Token(invalid("invalid ebnf (\(expectedCh) expected)"), false)
        } else {
            getToken()
        }
    }

    private func addIdent(_ ident: String) -> Int {
        if let k = idents.firstIndex(of: ident) {
            return k
        } else {
            idents.append(ident)
            let k = idents.count - 1
            ididx.append(-1)
            return k
        }
    }

    private func factor() -> Any {
        let res: Any

        if token.isSequence {
            let t = token.value as! Sequence
            if let firstItem = t[0] as? String, firstItem == "ident" {
                let identName = t[1] as! String
                let idx = addIdent(identName)
                t.add(idx)
                token = Token(t, true)
            }
            res = token.value
            getToken()
        } else if let tokenChar = token.value as? Character {
            switch tokenChar {
            case "[":
                getToken()
                let result = Sequence("optional", expression())
                matchToken("]")
                res = result
            case "(":
                getToken()
                let result = expression()
                matchToken(")")
                res = result
            case "{":
                getToken()
                let result = Sequence("repeat", expression())
                matchToken("}")
                res = result
            default:
                fatalError("invalid token in factor() function")
            }
        } else {
            fatalError("invalid token in factor() function")
        }

        if let sequence = res as? Sequence, sequence.count == 1 {
            return sequence[0]
        }
        return res
    }

    private func term() -> Any {
        let res = Sequence(factor())
        let tokens: Set<Character> = ["|", ".", ";", ")", "]", "}"]

        while true {
            if let tokenChar = token.value as? Character, tokens.contains(tokenChar) {
                break
            }
            if let tokenInt = token.value as? Int, tokenInt == -1 {
                break
            }
            res.add(factor())
        }

        return res.count == 1 ? res[0] : res
    }

    private func expression() -> Any {
        var res = Sequence(term())
        if let tokenChar = token.value as? Character, tokenChar == "|" {
            res = Sequence("or", res[0])
            while let tokenChar = token.value as? Character, tokenChar == "|" {
                getToken()
                res.add(term())
            }
        }
        return res.count == 1 ? res[0] : res
    }

    private func production() -> Any {
        // Returns a token or -1; the real result is left in 'productions' etc,
        getToken()
        if let tokenChar = token.value as? Character, tokenChar != "}" {
            if let tokenInt = token.value as? Int, tokenInt == -1 {
                return invalid("invalid ebnf (missing closing })")
            }
            if !token.isSequence {
                return -1
            }
            let t = token.value as! Sequence
            if let firstItem = t[0] as? String, firstItem != "ident" {
                return -1
            }
            let ident = t[1] as! String
            let idx = addIdent(ident)
            getToken()
            matchToken("=")
            if let tokenInt = token.value as? Int, tokenInt == -1 {
                return -1
            }
            productions.append(Sequence(ident, idx, expression()))
            ididx[idx] = productions.count - 1
        }
        return token.value
    }

    private func parse(_ ebnf: String) -> Int {
        // Returns +1 if ok, -1 if bad.
        print("parse:\n\(ebnf) ===>\n")
        err = false
        src = ebnf
        sdx = 0
        idents.removeAll()
        ididx.removeAll()
        productions.removeAll()
        extras = Sequence()

        getToken()
        if token.isSequence {
            let t = token.value as! Sequence
            t[0] = "title"
            extras.add(token.value)
            getToken()
        }
        if let tokenChar = token.value as? Character, tokenChar != "{" {
            return invalid("invalid ebnf (missing opening {)")
        }

        while true {
            let tokenResult = production()
            if let tokenChar = tokenResult as? Character, tokenChar == "}" {
                break
            }
            if let tokenInt = tokenResult as? Int, tokenInt == -1 {
                break
            }
        }

        getToken()
        if token.isSequence {
            let t = token.value as! Sequence
            t[0] = "comment"
            extras.add(token.value)
            getToken()
        }
        if let tokenInt = token.value as? Int, tokenInt != -1 {
            return invalid("invalid ebnf (missing eof?)")
        }
        if err {
            return -1
        }

        if let k = ididx.firstIndex(of: -1) {
            return invalid("invalid ebnf (undefined:\(idents[k]))")
        }

        pprint(productions, "productions")
        pprint(idents, "idents")
        pprint(ididx, "ididx")
        pprint(extras, "extras")
        return 1
    }

    // Adjusts Swift's normal printing to look more like Phix output.
    private func pprint(_ ob: Any, _ header: String) {
        print("\n\(header):")
        var pp = "\(ob)"
        pp = pp.replacingOccurrences(of: "[", with: "{")
        pp = pp.replacingOccurrences(of: "]", with: "}")
        pp = pp.replacingOccurrences(of: " ", with: ", ")
        for i in idents.indices {
            pp = pp.replacingOccurrences(of: "\(i)", with: "\(i)")
        }
        print(pp)
    }

    // The rules that applies() has to deal with are:
    // {factors} - if rule[0] is not string,
    // just apply one after the other recursively.
    // {"terminal", "a1"}       -- literal constants
    // {"or", <e1>, <e2>, ...}  -- (any) one of n
    // {"repeat", <e1>}         -- as per "{}" in ebnf
    // {"optional", <e1>}       -- as per "[]" in ebnf
    // {"ident", <name>, idx}   -- apply the sub-rule

    private func applies(_ rule: Sequence) -> Bool {
        let wasSdx = sdx // in case of failure
        let r1 = rule[0]

        if let r1String = r1 as? String {
            switch r1String {
            case "terminal":
                skipSpaces()
                let r2 = rule[1] as! String
                for char in r2 {
                    if sdx >= src.count {
                        sdx = wasSdx
                        return false
                    }
                    let index = src.index(src.startIndex, offsetBy: sdx)
                    if src[index] != char {
                        sdx = wasSdx
                        return false
                    }
                    sdx += 1
                }
            case "or":
                for i in 1..<rule.count {
                    if applies(rule[i] as! Sequence) {
                        return true
                    }
                }
                sdx = wasSdx
                return false
            case "repeat":
                while applies(rule[1] as! Sequence) {
                    // continue repeating
                }
            case "optional":
                _ = applies(rule[1] as! Sequence)
            case "ident":
                let i = rule[2] as! Int
                let ii = ididx[i]
                if !applies(productions[ii][2] as! Sequence) {
                    sdx = wasSdx
                    return false
                }
            default:
                fatalError("invalid rule in applies() function")
            }
        } else {
            // r1 is not a string, so apply each rule in sequence
            for i in 0..<rule.count {
                if !applies(rule[i] as! Sequence) {
                    sdx = wasSdx
                    return false
                }
            }
        }
        return true
    }

    private func checkValid(_ test: String) {
        src = test
        sdx = 0
        var res = applies(productions[0][2] as! Sequence)
        skipSpaces()
        if sdx < src.count {
            res = false
        }
        print("\"\(test)\", \(results[1 - boolToInt(res)])")
    }

    func run() {
        let ebnfs = [
            "\"a\" {\n" +
            "    a = \"a1\" ( \"a2\" | \"a3\" ) { \"a4\" } [ \"a5\" ] \"a6\" ;\n" +
            "} \"z\" ",

            "{\n" +
            "    expr = term { plus term } .\n" +
            "    term = factor { times factor } .\n" +
            "    factor = number | '(' expr ')' .\n" +
            " \n" +
            "    plus = \"+\" | \"-\" .\n" +
            "    times = \"*\" | \"/\" .\n" +
            " \n" +
            "    number = digit { digit } .\n" +
            "    digit = \"0\" | \"1\" | \"2\" | \"3\" | \"4\" | \"5\" | \"6\" | \"7\" | \"8\" | \"9\" .\n" +
            "}",

            "a = \"1\"",
            "{ a = \"1\" ;",
            "{ hello world = \"1\"; }",
            "{ foo = bar . }"
        ]

        let tests = [
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

        for i in ebnfs.indices {
            if parse(ebnfs[i]) == 1 {
                print("\ntests:")
                if i < tests.count {
                    for test in tests[i] {
                        checkValid(test)
                    }
                }
            }
            print()
        }
    }
}

// Usage
let parser = EBNFParser()
parser.run()
