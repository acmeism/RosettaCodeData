import "./str" for Char
import "./fmt" for Fmt

class RDP {
    construct parse(source) {
        _src = source
        _sdx = 0
        _ch  = null
        _tok = null
        _nxt = 1
        nextToken()
        var ast = sumExpr()
        if (_tok[0] != "EOF") Fiber.abort("Something went wrong.")
        printAst(ast, 0)
        System.print()
        showAst(ast)
    }

    skipSpaces() {
        while (true) {
            if (_sdx >= _src.count) return
            _ch = _src[_sdx]
            if (!" \t\r\n".contains(_ch)) return
            _sdx = _sdx + 1
        }
    }

    // yields one of:
    //   ["SYMBOL", ch] where ch is one of "()+-/*", or
    //   ["IDENT", string] or ["EOF"]
    nextToken() {
        skipSpaces()
        var tokStart = _sdx
        if (_sdx >= _src.count) {
            _tok = ["EOF"]
        } else if ("()+-/*".contains(_ch)) {
            _sdx = _sdx + 1
            _tok = ["SYMBOL", _ch]
        } else if (Char.isAsciiLetter(_ch)) {
            while (true) {
                _sdx = _sdx + 1
                if (_sdx >= _src.count) break
                _ch = _src[_sdx]
                if (!Char.isAsciiAlphaNum(_ch) && _ch != "_") break
            }
            _tok = ["IDENT", _src[tokStart..._sdx]]
        } else {
            Fiber.abort("Invalid token '%(_ch)'.")
        }
    }

    primary() {
        var res = []
        if (_tok[0] == "IDENT") {
            res = _tok.toList
            nextToken()
        } else if (_tok[0] == "SYMBOL" && _tok[1] == "(") {
            nextToken()
            res = sumExpr()
            if (_tok[0] != "SYMBOL" || _tok[1] != ")") Fiber.abort("Unexpected token '%(_tok)'.")
            nextToken()
        } else {
            Fiber.abort("Unexpected token '%(_tok)'.")
        }
        return res
    }

    mulExpr() {
        var res = primary()
        while (true) {
            if (_tok[0] != "SYMBOL" || !"*/".contains(_tok[1])) break
            res = [_tok, res, null]
            nextToken()
            res[2] = primary()
        }
        return res
    }

    sumExpr() {
        var res = mulExpr()
        while (true) {
            if (_tok[0] != "SYMBOL" || !"+-".contains(_tok[1])) break
            res = [_tok, res, null]
            nextToken()
            res[2] = mulExpr()
        }
        return res
    }

    showAst(ast) {
        if (ast[0][0] == "SYMBOL") {
            var op = ast[0][1]
            var lhs = showAst(ast[1])
            var rhs = showAst(ast[2])
            var thiz = Fmt.swrite("_$04d", _nxt)
            Fmt.print("$s = $s $s $s", thiz, lhs, op, rhs)
            _nxt = _nxt + 1
            return thiz
        } else if (ast[0] == "IDENT") {
            return ast[1]
        }
        Fiber.abort("Something went wrong.")
    }

    printAst(ast, level) {
        for (e in ast) {
            var indent = "  " * level
            if (!(e is List)) {
                System.print(indent + e)
            } else {
                System.print(indent + "{")
                printAst(e, level+1)
                System.print(indent + "}")
            }
        }
    }
}

RDP.parse("(one + two) * three - four * five")
