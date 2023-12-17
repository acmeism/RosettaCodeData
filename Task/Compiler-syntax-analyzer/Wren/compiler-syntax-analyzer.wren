import "./dynamic" for Enum, Struct, Tuple
import "./fmt" for Fmt
import "./ioutil" for FileUtil

var tokens = [
    "EOI",
    "Mul",
    "Div",
    "Mod",
    "Add",
    "Sub",
    "Negate",
    "Not",
    "Lss",
    "Leq",
    "Gtr",
    "Geq",
    "Eql",
    "Neq",
    "Assign",
    "And",
    "Or",
    "If",
    "Else",
    "While",
    "Print",
    "Putc",
    "Lparen",
    "Rparen",
    "Lbrace",
    "Rbrace",
    "Semi",
    "Comma",
    "Ident",
    "Integer",
    "String"
]

var Token = Enum.create("Token", tokens)

var nodes = [
    "Ident",
    "String",
    "Integer",
    "Sequence",
    "If",
    "Prtc",
    "Prts",
    "Prti",
    "While",
    "Assign",
    "Negate",
    "Not",
    "Mul",
    "Div",
    "Mod",
    "Add",
    "Sub",
    "Lss",
    "Leq",
    "Gtr",
    "Geq",
    "Eql",
    "Neq",
    "And",
    "Or"
]

var Node = Enum.create("Node", nodes)

// 'text' field represents ident ot string literal or integer value
var TokS = Struct.create("TokS", ["tok", "errLn", "errCol", "text"])

var Tree = Struct.create("Tree", ["nodeType", "left", "right", "value"])

// dependency: Ordered by tok, must remain in same order as Token enum constants
var Atr = Tuple.create("Atr", ["text", "enumText", "tok", "rightAssociative", "isBinary",
                               "isUnary", "precedence", "nodeType"])

var atrs = [
    Atr.new("EOI", "End_of_input", Token.EOI, false, false, false, -1, -1),
    Atr.new("*", "Op_multiply", Token.Mul, false, true, false, 13, Node.Mul),
    Atr.new("/", "Op_divide", Token.Div, false, true, false, 13, Node.Div),
    Atr.new("\%", "Op_mod", Token.Mod, false, true, false, 13, Node.Mod),
    Atr.new("+", "Op_add", Token.Add, false, true, false, 12, Node.Add),
    Atr.new("-", "Op_subtract", Token.Sub, false, true, false, 12, Node.Sub),
    Atr.new("-", "Op_negate", Token.Negate, false, false, true, 14, Node.Negate),
    Atr.new("!", "Op_not", Token.Not, false, false, true, 14, Node.Not),
    Atr.new("<", "Op_less", Token.Lss, false, true, false, 10, Node.Lss),
    Atr.new("<=", "Op_lessequal", Token.Leq, false, true, false, 10, Node.Leq),
    Atr.new(">", "Op_greater", Token.Gtr, false, true, false, 10, Node.Gtr),
    Atr.new(">=", "Op_greaterequal", Token.Geq, false, true, false, 10, Node.Geq),
    Atr.new("==", "Op_equal", Token.Eql, false, true, false, 9, Node.Eql),
    Atr.new("!=", "Op_notequal", Token.Neq, false, true, false, 9, Node.Neq),
    Atr.new("=", "Op_assign", Token.Assign, false, false, false, -1, Node.Assign),
    Atr.new("&&", "Op_and", Token.And, false, true, false, 5, Node.And),
    Atr.new("||", "Op_or", Token.Or, false, true, false, 4, Node.Or),
    Atr.new("if", "Keyword_if", Token.If, false, false, false, -1, Node.If),
    Atr.new("else", "Keyword_else", Token.Else, false, false, false, -1, -1),
    Atr.new("while", "Keyword_while", Token.While, false, false, false, -1, Node.While),
    Atr.new("print", "Keyword_print", Token.Print, false, false, false, -1, -1),
    Atr.new("putc", "Keyword_putc", Token.Putc, false, false, false, -1, -1),
    Atr.new("(", "LeftParen", Token.Lparen, false, false, false, -1, -1),
    Atr.new(")", "RightParen", Token.Rparen, false, false, false, -1, -1),
    Atr.new("{", "LeftBrace", Token.Lbrace, false, false, false, -1, -1),
    Atr.new("}", "RightBrace", Token.Rbrace, false, false, false, -1, -1),
    Atr.new(";", "Semicolon", Token.Semi, false, false, false, -1, -1),
    Atr.new(",", "Comma", Token.Comma, false, false, false, -1, -1),
    Atr.new("Ident", "Identifier", Token.Ident, false, false, false, -1, Node.Ident),
    Atr.new("Integer literal", "Integer", Token.Integer, false, false, false, -1, Node.Integer),
    Atr.new("String literal", "String", Token.String, false, false, false, -1, Node.String),
]

var displayNodes = [
    "Identifier", "String", "Integer", "Sequence", "If", "Prtc", "Prts", "Prti",
    "While", "Assign", "Negate", "Not", "Multiply", "Divide", "Mod", "Add",
    "Subtract", "Less", "LessEqual", "Greater", "GreaterEqual", "Equal",
    "NotEqual", "And", "Or"
]

var token = TokS.new(0, 0, 0, "")

var reportError = Fn.new { |eline, ecol, msg| Fiber.abort("(%(eline):%(ecol)) error : %(msg)") }

// return internal version of name
var getEnum = Fn.new { |name|
    for (atr in atrs) {
        if (atr.enumText == name) return atr.tok
    }
    reportError.call(0, 0, "Unknown token %(name)")
}

var lines = []
var lineCount = 0
var lineNum = 0

var getTok = Fn.new {
    var tok = TokS.new(0, 0, 0, "")
    if (lineNum < lineCount) {
        var line = lines[lineNum].trimEnd(" \t")
        lineNum = lineNum + 1
        var fields = line.split(" ").where { |s| s != "" }.toList
        // [ ]*{lineno}[ ]+{colno}[ ]+token[ ]+optional
        tok.errLn = Num.fromString(fields[0])
        tok.errCol = Num.fromString(fields[1])
        tok.tok = getEnum.call(fields[2])
        var le = fields.count
        if (le == 4) {
            tok.text = fields[3]
        } else if (le > 4) {
            var idx = line.indexOf("\"")
            tok.text = line[idx..-1]
        }
    }
    return tok
}

var makeNode = Fn.new { |nodeType, left, right| Tree.new(nodeType, left, right, "") }

var makeLeaf = Fn.new { |nodeType, value| Tree.new(nodeType, null, null, value) }

var expect = Fn.new { |msg, s|
    if (token.tok == s) {
        token = getTok.call()
        return
    }
    reportError.call(token.errLn, token.errCol,
        Fmt.swrite("$s: Expecting '$s', found '$s'", msg, atrs[s].text, atrs[token.tok].text))
}

var parenExpr  // forward reference

var expr // recursive function
expr = Fn.new { |p|
    var x
    var node
    var t = token.tok
    if (t == Token.Lparen) {
        x = parenExpr.call()
    } else if (t == Token.Sub || t == Token.Add) {
        var op = t
        token = getTok.call()
        node = expr.call(atrs[Token.Negate].precedence)
        if (op == Token.Sub) {
            x = makeNode.call(Node.negate, node, null)
        } else {
            x = node
        }
    } else if (t == Token.Not) {
        token = getTok.call()
        x = makeNode.call(Node.Not, expr.call(atrs[Token.Not].precedence), null)
    } else if (t == Token.Ident) {
        x = makeLeaf.call(Node.Ident, token.text)
        token = getTok.call()
    } else if (t == Token.Integer) {
        x = makeLeaf.call(Node.Integer, token.text)
        token = getTok.call()
    } else {
        reportError.call(token.errLn, token.errCol,
            Fmt.swrite("Expecting a primary, found: $s", atrs[token.tok].text))
    }

    while (atrs[token.tok].isBinary && atrs[token.tok].precedence >= p) {
        var op = token.tok
        token = getTok.call()
        var q = atrs[op].precedence
        if (!atrs[op].rightAssociative) q = q + 1
        node = expr.call(q)
        x = makeNode.call(atrs[op].nodeType, x, node)
    }
    return x
}

parenExpr = Fn.new {
    expect.call("parenExpr", Token.Lparen)
    var t = expr.call(0)
    expect.call("parenExpr", Token.Rparen)
    return t
}

var stmt // recursive function
stmt = Fn.new {
    var t
    var v
    var e
    var s
    var s2
    var tt = token.tok
    if (tt == Token.If) {
        token = getTok.call()
        e = parenExpr.call()
        s = stmt.call()
        s2 = null
        if (token.tok == Token.Else) {
            token = getTok.call()
            s2 = stmt.call()
        }
        t = makeNode.call(Node.If, e, makeNode.call(Node.If, s, s2))
    } else if (tt == Token.Putc) {
        token = getTok.call()
        e = parenExpr.call()
        t = makeNode.call(Node.Prtc, e, null)
        expect.call("Putc", Token.Semi)
    } else if (tt == Token.Print) { // print '(' expr {',' expr} ')'
        token = getTok.call()
        expect.call("Print", Token.Lparen)
        while (true) {
            if (token.tok == Token.String) {
                e = makeNode.call(Node.Prts, makeLeaf.call(Node.String, token.text), null)
                token = getTok.call()
            } else {
                e = makeNode.call(Node.Prti, expr.call(0), null)
            }
            t = makeNode.call(Node.Sequence, t, e)
            if (token.tok != Token.Comma) break
            expect.call("Print", Token.Comma)
        }
        expect.call("Print", Token.Rparen)
        expect.call("Print", Token.Semi)
    } else if (tt == Token.Semi) {
        token = getTok.call()
    } else if (tt == Token.Ident) {
        v = makeLeaf.call(Node.Ident, token.text)
        token = getTok.call()
        expect.call("assign", Token.Assign)
        e = expr.call(0)
        t = makeNode.call(Node.Assign, v, e)
        expect.call("assign", Token.Semi)
    } else if (tt == Token.While) {
        token = getTok.call()
        e = parenExpr.call()
        s = stmt.call()
        t = makeNode.call(Node.While, e, s)
    } else if (tt == Token.Lbrace) { // {stmt}
        expect.call("Lbrace", Token.Lbrace)
        while (token.tok != Token.Rbrace && token.tok != Token.EOI) {
            t = makeNode.call(Node.Sequence, t, stmt.call())
        }
        expect.call("Lbrace", Token.Rbrace)
    } else if (tt == Token.EOI) {
        // do nothing
    } else {
        reportError.call(token.errLn, token.errCol,
            Fmt.Swrite("expecting start of statement, found '$s'", atrs[token.tok].text))
    }
    return t
}

var parse = Fn.new {
    var t
    token = getTok.call()
    while (true) {
        t = makeNode.call(Node.Sequence, t, stmt.call())
        if (!t || token.tok == Token.EOI) break
    }
    return t
}

var prtAst  // recursive function
prtAst = Fn.new { |t|
    if (!t) {
        System.print(";")
    } else {
        Fmt.write("$-14s ", displayNodes[t.nodeType])
        if (t.nodeType == Node.Ident || t.nodeType == Node.Integer || t.nodeType == Node.String) {
            System.print(t.value)
        } else {
            System.print()
            prtAst.call(t.left)
            prtAst.call(t.right)
        }
    }
}

lines = FileUtil.readLines("source.txt")
lineCount = lines.count
prtAst.call(parse.call())
