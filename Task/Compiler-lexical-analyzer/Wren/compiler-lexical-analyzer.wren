import "/dynamic" for Enum, Struct, Tuple
import "/str" for Char
import "/fmt" for Fmt
import "/ioutil" for FileUtil
import "os" for Process

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
    "Eq",
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

var TokData = Struct.create("TokData", ["eline", "ecol", "tok", "v"])

var Symbol = Tuple.create("Symbol", ["name", "tok"])

// symbol table
var symtab = []

var curLine = ""
var curCh = ""
var lineNum = 0
var colNum = 0
var etx = 4  // used to signify EOI

var lines = []
var lineCount = 0

var errorMsg = Fn.new { |eline, ecol, msg| Fiber.abort("(%(eline):%(ecol)) %(msg)") }

// add an identifier to the symbpl table
var install = Fn.new { |name, tok|
    var sym = Symbol.new(name, tok)
    symtab.add(sym)
}

// search for an identifier in the symbol table
var lookup = Fn.new { |name|
    for (i in 0...symtab.count) {
        if (symtab[i].name == name) return i
    }
    return -1
}

// read the next line of input from the source file
var nextLine  // recursive function
nextLine = Fn.new {
    if (lineNum == lineCount) {
        curCh = etx
        curLine = ""
        colNum = 1
        return
    }
    curLine = lines[lineNum]
    lineNum = lineNum + 1
    colNum = 0
    if (curLine == "") nextLine.call()  // skip blank lines
}

// get the next char
var nextChar = Fn.new {
    if (colNum >= curLine.count) nextLine.call()
    if (colNum < curLine.count) {
        curCh = curLine[colNum]
        colNum = colNum + 1
    }
}

var follow = Fn.new { |eline, ecol, expect, ifyes, ifno|
    if (curCh == expect) {
        nextChar.call()
        return ifyes
    }
    if (ifno == Token.EOI) {
        errorMsg.call(eline, ecol, "follow unrecognized character: " + curCh)
    }
    return ifno
}

var getTok  // recursive function
getTok = Fn.new {
    // skip whitespace
    while (curCh == " " || curCh == "\t" || curCh == "\n") nextChar.call()
    var td = TokData.new(lineNum, colNum, 0, "")
    if (curCh == etx) {
        td.tok = Token.EOI
        return td
    }
    if (curCh == "{") {
        td.tok = Token.Lbrace
        nextChar.call()
        return td
    }
    if (curCh == "}") {
        td.tok = Token.Rbrace
        nextChar.call()
        return td
    }
    if (curCh == "(") {
        td.tok = Token.Lparen
        nextChar.call()
        return td
    }
    if (curCh == ")") {
        td.tok = Token.Rparen
        nextChar.call()
        return td
    }
    if (curCh == "+") {
        td.tok = Token.Add
        nextChar.call()
        return td
    }
    if (curCh == "-") {
        td.tok = Token.Sub
        nextChar.call()
        return td
    }
    if (curCh == "*") {
        td.tok = Token.Mul
        nextChar.call()
        return td
    }
    if (curCh == "\%") {
        td.tok = Token.Mod
        nextChar.call()
        return td
    }
    if (curCh == ";") {
        td.tok = Token.Semi
        nextChar.call()
        return td
    }
    if (curCh == ",") {
        td.tok = Token.Comma
        nextChar.call()
        return td
    }
    if (curCh == "'") { // single char literals
        nextChar.call()
        td.v = curCh.bytes[0].toString
        if (curCh == "'") {
            errorMsg.call(td.eline, td.ecol, "Empty character constant")
        }
        if (curCh == "\\") {
            nextChar.call()
            if (curCh == "n") {
                td.v = "10"
            } else if (curCh == "\\") {
                td.v = "92"
            } else {
                errorMsg.call(td.eline, td.ecol, "unknown escape sequence: "+ curCh)
            }
        }
        nextChar.call()
        if (curCh != "'") {
            errorMsg.call(td.eline, td.ecol, "multi-character constant")
        }
        nextChar.call()
        td.tok = Token.Integer
        return td
    }
    if (curCh == "<") {
        nextChar.call()
        td.tok = follow.call(td.eline, td.ecol, "=",  Token.Leq, Token.Lss)
        return td
    }
    if (curCh == ">") {
        nextChar.call()
        td.tok = follow.call(td.eline, td.ecol, "=", Token.Geq, Token.Gtr)
        return td
    }
    if (curCh == "!") {
        nextChar.call()
        td.tok = follow.call(td.eline, td.ecol, "=", Token.Neq, Token.Not)
        return td
    }
    if (curCh == "=") {
        nextChar.call()
        td.tok = follow.call(td.eline, td.ecol, "=", Token.Eq, Token.Assign)
        return td
    }
    if (curCh == "&") {
        nextChar.call()
        td.tok = follow.call(td.eline, td.ecol, "&", Token.And, Token.EOI)
        return td
    }
    if (curCh == "|") {
        nextChar.call()
        td.tok = follow.call(td.eline, td.ecol, "|", Token.Or, Token.EOI)
        return td
    }
    if (curCh == "\"") { // string
        td.v = curCh
        nextChar.call()
        while (curCh != "\"") {
            if (curCh == "\n") {
                errorMsg.call(td.eline, td.ecol, "EOL in string")
            }
            if (curCh == etx) {
                errorMsg.call(td.eline, td.ecol, "EOF in string")
            }
            td.v = td.v + curCh
            nextChar.call()
        }
        td.v = td.v + curCh
        nextChar.call()
        td.tok = Token.String
        return td
    }
    if (curCh == "/") { // div or comment
        nextChar.call()
        if (curCh != "*") {
            td.tok = Token.Div
            return td
        }
        // skip comments
        nextChar.call()
        while (true) {
            if (curCh == "*") {
                nextChar.call()
                if (curCh == "/") {
                    nextChar.call()
                    return getTok.call()
                }
            } else if (curCh == etx) {
                errorMsg.call(td.eline, td.ecol, "EOF in comment")
            } else {
                nextChar.call()
            }
        }
    }
    //integers or identifiers
    var isNumber = Char.isDigit(curCh)
    td.v = ""
    while (Char.isAsciiAlphaNum(curCh) || curCh == "_") {
        if (!Char.isDigit(curCh)) isNumber = false
        td.v = td.v + curCh
        nextChar.call()
    }
    if (td.v.count == 0) {
        errorMsg.call(td.eline, td.ecol, "unknown character: " + curCh)
    }
    if (Char.isDigit(td.v[0])) {
        if (!isNumber) {
            errorMsg.call(td.eline, td.ecol, "invalid number: " + curCh)
        }
        td.tok = Token.Integer
        return td
    }
    var index = lookup.call(td.v)
    td.tok = (index == -1) ? Token.Ident : symtab[index].tok
    return td
}

var initLex = Fn.new {
    install.call("else", Token.Else)
    install.call("if", Token.If)
    install.call("print", Token.Print)
    install.call("putc", Token.Putc)
    install.call("while", Token.While)
    nextChar.call()
}

var process = Fn.new {
    var tokMap = {}
    tokMap[Token.EOI]     = "End_of_input"
    tokMap[Token.Mul]     = "Op_multiply"
    tokMap[Token.Div]     = "Op_divide"
    tokMap[Token.Mod]     = "Op_mod"
    tokMap[Token.Add]     = "Op_add"
    tokMap[Token.Sub]     = "Op_subtract"
    tokMap[Token.Negate]  = "Op_negate"
    tokMap[Token.Not]     = "Op_not"
    tokMap[Token.Lss]     = "Op_less"
    tokMap[Token.Leq]     = "Op_lessequal"
    tokMap[Token.Gtr]     = "Op_greater"
    tokMap[Token.Geq]     = "Op_greaterequal"
    tokMap[Token.Eq]      = "Op_equal"
    tokMap[Token.Neq]     = "Op_notequal"
    tokMap[Token.Assign]  = "Op_assign"
    tokMap[Token.And]     = "Op_and"
    tokMap[Token.Or]      = "Op_or"
    tokMap[Token.If]      = "Keyword_if"
    tokMap[Token.Else]    = "Keyword_else"
    tokMap[Token.While]   = "Keyword_while"
    tokMap[Token.Print]   = "Keyword_print"
    tokMap[Token.Putc]    = "Keyword_putc"
    tokMap[Token.Lparen]  = "LeftParen"
    tokMap[Token.Rparen]  = "RightParen"
    tokMap[Token.Lbrace]  = "LeftBrace"
    tokMap[Token.Rbrace]  = "RightBrace"
    tokMap[Token.Semi]    = "Semicolon"
    tokMap[Token.Comma]   = "Comma"
    tokMap[Token.Ident]   = "Identifier"
    tokMap[Token.Integer] = "Integer"
    tokMap[Token.String]  = "String"

    while (true) {
        var td = getTok.call()
        Fmt.write("$5d  $5d $-16s", td.eline, td.ecol, tokMap[td.tok])
        if (td.tok == Token.Integer || td.tok == Token.Ident || td.tok == Token.String) {
            System.print(td.v)
        } else {
            System.print()
        }
        if (td.tok == Token.EOI) return
    }
}

var args = Process.arguments
if (args.count == 0) {
    System.print("Filename required")
    return
}

lines = FileUtil.readLines(args[0])
lineCount = lines.count
initLex.call()
process.call()
