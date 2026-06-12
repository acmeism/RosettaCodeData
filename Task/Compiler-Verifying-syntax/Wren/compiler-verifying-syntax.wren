import "./dynamic" for Enum
import "./str" for Char

var Token = Enum.create(
    "Token", ["error", "ident", "int", "lpar", "rpar", "False", "True",
    "lt", "eq", "add", "sub", "mul", "div", "or", "and", "not", "eof"]
)

var Token2Text = {
    Token.error: "invalid token", Token.ident: "identifier", Token.int: "integer",
    Token.lpar: "'('", Token.rpar: "')'", Token.False: "'false'", Token.True: "'true'",
    Token.lt: "'<'", Token.eq: "'='", Token.add: "'+'", Token.sub: "'-'",
    Token.mul: "'*'", Token.div: "'/'", Token.or: "'or'", Token.and: "'and'",
    Token.not: "'not'", Token.eof: "EOF"
}

var IdentTokens = {
    "false": Token.False, "true": Token.True, "or": Token.or,
    "and": Token.and, "not": Token.not
}

var CharTokens = {
    "(": Token.lpar, ")": Token.rpar, "<": Token.lt, "=": Token.eq,
    "+": Token.add, "-": Token.sub, "*": Token.mul, "/": Token.div
}

var IsIdentChar = Fn.new { |c| Char.isAsciiAlphaNum(c) || c == "_" }

class Lexer {
    static init(s) {
        var lex = Lexer.new(s, s.count, 0, "", "")
        lex.nextToken
        return lex
    }

    construct new(str, len, pos, token, error) {
        _str   = str     // string to parse
        _len   = len     // string length
        _pos   = pos     // current lexer position
        _token = token   // current token
        _error = error   // error message
    }

    // property getters required
    pos   { _pos }
    error { _error }

    // get the token for an identifier
    getIdToken {
        var s = ""
        while (_pos < _len && IsIdentChar.call(_str[_pos])) {
          s = s + _str[_pos]
          _pos = _pos + 1
        }
        _token = IdentTokens.containsKey(s) ? IdentTokens[s] : Token.ident
    }

    // get an integer token
    getInt {
        while (_pos < _len && Char.isDigit(_str[_pos])) _pos = _pos + 1
        _token = Token.int
    }

    // find the next token
    nextToken {
        // skip spaces
        while (_pos < _len && _str[_pos] == " ") _pos = _pos + 1
        if (_pos == _len) {
            _token = Token.eof
        } else {
            var ch = _str[_pos]
            if (Char.isAsciiLower(ch)) {
                getIdToken
            } else if (Char.isDigit(ch)) {
                getInt
            } else {
                _pos = _pos + 1
                _token = CharTokens.containsKey(ch) ? CharTokens[ch] : Token.error
            }
        }
    }

    // check validity of a primary
    checkPrimary {
        if ([Token.ident, Token.int, Token.False, Token.True].contains(_token)) {
            nextToken
            return true
        } else if (_token == Token.lpar) {
            nextToken
            if (!checkExpr) return false
            if (_token != Token.rpar) {
                _error = "Encountered %(Token2Text[_token]); expected ')'"
                return false
            } else {
                nextToken
                return true
            }
        } else {
            _error = "Encountered %(Token2Text[_token]); expected identifier, literal or '('"
            return false
        }
    }

    // check validity of an expr6
    checkExpr6 {
        if (!checkPrimary) return false
        while ([Token.mul, Token.div].contains(_token)) {
            nextToken
            if (!checkPrimary) return false
        }
        return true
    }

    // check validity of an expr5
    checkExpr5 {
        if (!checkExpr6) return false
        while ([Token.add, Token.sub].contains(_token)) {
            nextToken
            if (!checkExpr6) return false
        }
        return true
    }

    // check validity of an expr4
    checkExpr4 {
        if (_token == Token.not) nextToken
        if (!checkExpr5) return false
        if ([Token.lt, Token.eq].contains(_token)) {
            nextToken
            if (!checkExpr5) return false
        }
        return true
    }

    // check validity of an expr3
    checkExpr3 {
        if (!checkExpr4) return false
        while (_token == Token.and) {
            nextToken
            if (!checkExpr4) return false
        }
        return true
    }

    // check validity of an expr2
    checkExpr2 {
        if (!checkExpr3) return false
        while (_token == Token.or) {
            nextToken
            if (!checkExpr3) return false
        }
        return true
    }

    // check validity of an expr
    checkExpr { checkExpr2 }

    // check validity of a statement
    checkStmt {
        var result = checkExpr
        if (result && _pos < _len) {
            _error = "Extra characters at end of statement."
            result = false
        }
        return result
    }
}

// using test set from Algol68 version

var tests = [
    "wombat",
    "wombat or monotreme",
    "( wombat and not )",
    "wombat or not",
    "a + 1",
    "a + b < c",
    "a + b - c * d / e < f and not ( g = h )",
    "a + b - c * d / e < f and not ( g = h",
    "a = b",
    "a or b = c",
    "$",
    "true or false = not true",
    "not true = false",
    "3 + not 5",
    "3 + (not 5)",
    "(42 + 3",
    " not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true",
    " and 3 < 2",
    "not 7 < 2",
    "2 < 3 < 4",
    "2 < foobar - 3 < 4",
    "2 < foobar and 3 < 4",
    "4 * (32 - 16) + 9 = 73",
    "235 76 + 1",
    "a + b = not c and false",
    "a + b = (not c) and false",
    "a + b = (not c and false)",
    "ab_c / bd2 or < e_f7",
    "g not = h",
    "été = false",
    "i++",
    "j & k",
    "l or _m"
]

for (test in tests) {
    var lex = Lexer.init(test)
    var ok = lex.checkStmt
    System.print("%(test) -> %(ok)")
    if (!ok) {
        System.print("*** Error at position %(lex.pos). %(lex.error)\n")
    }
}
