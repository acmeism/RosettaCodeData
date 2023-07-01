/*
    Token: type, value, line, pos
*/

const TokenType = {
    Keyword_if: 1, Keyword_else: 2, Keyword_print: 3, Keyword_putc: 4, Keyword_while: 5,
    Op_add: 6, Op_and: 7, Op_assign: 8, Op_divide: 9, Op_equal: 10, Op_greater: 11,
    Op_greaterequal: 12, Op_less: 13, Op_Lessequal: 14, Op_mod: 15, Op_multiply: 16, Op_not: 17,
    Op_notequal: 18, Op_or: 19, Op_subtract: 20,
    Integer: 21, String: 22, Identifier: 23,
    Semicolon: 24, Comma: 25,
    LeftBrace: 26, RightBrace: 27,
    LeftParen: 28, RightParen: 29,
    End_of_input: 99
}

class Lexer {
    constructor(source) {
        this.source = source
        this.pos = 1        // position in line
        this.position = 0   // position in source
        this.line = 1
        this.chr = this.source.charAt(0)
        this.keywords = {
            "if": TokenType.Keyword_if,
            "else": TokenType.Keyword_else,
            "print": TokenType.Keyword_print,
            "putc": TokenType.Keyword_putc,
            "while": TokenType.Keyword_while
        }
    }
    getNextChar() {
        this.pos++
        this.position++

        if (this.position >= this.source.length) {
            this.chr = undefined
            return this.chr
        }
        this.chr = this.source.charAt(this.position)
        if (this.chr === '\n') {
            this.line++
            this.pos = 0
        }
        return this.chr
    }
    error(line, pos, message) {
        if (line > 0 && pos > 0) {
            console.log(message + " in line " + line + ", pos " + pos + "\n")
        } else {
            console.log(message)
        }
        process.exit(1)
    }
    follow(expect, ifyes, ifno, line, pos) {
        if (this.getNextChar() === expect) {
            this.getNextChar()
            return { type: ifyes, value: "", line, pos }
        }
        if (ifno === TokenType.End_of_input) {
            this.error(line, pos, "follow: unrecognized character: (" + this.chr.charCodeAt(0) + ") '" + this.chr + "'")
        }
        return { type: ifno, value: "", line, pos }
    }
    div_or_comment(line, pos) {
        if (this.getNextChar() !== '*') {
            return { type: TokenType.Op_divide, value: "/", line, pos }
        }
        this.getNextChar()
        while (true) {
            if (this.chr === '\u0000') {
                this.error(line, pos, "EOF in comment")
            } else if (this.chr === '*') {
                if (this.getNextChar() === '/') {
                    this.getNextChar()
                    return this.getToken()
                }
            } else {
                this.getNextChar()
            }
        }
    }
    char_lit(line, pos) {
        let c = this.getNextChar() // skip opening quote
        let n = c.charCodeAt(0)
        if (c === "\'") {
            this.error(line, pos, "empty character constant")
        } else if (c === "\\") {
            c = this.getNextChar()
            if (c == "n") {
                n = 10
            } else if (c === "\\") {
                n = 92
            } else {
                this.error(line, pos, "unknown escape sequence \\" + c)
            }
        }
        if (this.getNextChar() !== "\'") {
            this.error(line, pos, "multi-character constant")
        }
        this.getNextChar()
        return { type: TokenType.Integer, value: n, line, pos }
    }
    string_lit(start, line, pos) {
        let value = ""
        while (this.getNextChar() !== start) {
            if (this.chr === undefined) {
                this.error(line, pos, "EOF while scanning string literal")
            }
            if (this.chr === "\n") {
                this.error(line, pos, "EOL while scanning string literal")
            }
            value += this.chr
        }
        this.getNextChar()
        return { type: TokenType.String, value, line, pos }
    }
    identifier_or_integer(line, pos) {
        let is_number = true
        let text = ""

        while (/\w/.test(this.chr) || this.chr === '_') {
            text += this.chr
            if (!/\d/.test(this.chr)) {
                is_number = false
            }
            this.getNextChar()
        }
        if (text === "") {
            this.error(line, pos, "identifer_or_integer unrecopgnized character: follow: unrecognized character: (" + this.chr.charCodeAt(0) + ") '" + this.chr + "'")
        }

        if (/\d/.test(text.charAt(0))) {
            if (!is_number) {
                this.error(line, pos, "invaslid number: " + text)
            }
            return { type: TokenType.Integer, value: text, line, pos }
        }

        if (text in this.keywords) {
            return { type: this.keywords[text], value: "", line, pos }
        }
        return { type: TokenType.Identifier, value: text, line, pos }
    }
    getToken() {
        let pos, line
        // Ignore whitespaces
        while (/\s/.test(this.chr)) { this.getNextChar() }
        line = this.line; pos = this.pos
        switch (this.chr) {
            case undefined: return { type: TokenType.End_of_input, value: "", line: this.line, pos: this.pos }
            case "/":       return this.div_or_comment(line, pos)
            case "\'":      return this.char_lit(line, pos)
            case "\"":      return this.string_lit(this.chr, line, pos)

            case "<":       return this.follow("=", TokenType.Op_lessequal, TokenType.Op_less, line, pos)
            case ">":       return this.follow("=", TokenType.Op_greaterequal, TokenType.Op_greater, line, pos)
            case "=":       return this.follow("=", TokenType.Op_equal, TokenType.Op_assign, line, pos)
            case "!":       return this.follow("=", TokenType.Op_notequal, TokenType.Op_not, line, pos)
            case "&":       return this.follow("&", TokenType.Op_and, TokenType.End_of_input, line, pos)
            case "|":       return this.follow("|", TokenType.Op_or, TokenType.End_of_input, line, pos)

            case "{":       this.getNextChar(); return { type: TokenType.LeftBrace, value: "{", line, pos }
            case "}":       this.getNextChar(); return { type: TokenType.RightBrace, value: "}", line, pos }
            case "(":       this.getNextChar(); return { type: TokenType.LeftParen, value: "(", line, pos }
            case ")":       this.getNextChar(); return { type: TokenType.RightParen, value: ")", line, pos }
            case "+":       this.getNextChar(); return { type: TokenType.Op_add, value: "+", line, pos }
            case "-":       this.getNextChar(); return { type: TokenType.Op_subtract, value: "-", line, pos }
            case "*":       this.getNextChar(); return { type: TokenType.Op_multiply, value: "*", line, pos }
            case "%":       this.getNextChar(); return { type: TokenType.Op_mod, value: "%", line, pos }
            case ";":       this.getNextChar(); return { type: TokenType.Semicolon, value: ";", line, pos }
            case ",":       this.getNextChar(); return { type: TokenType.Comma, value: ",", line, pos }

            default:        return this.identifier_or_integer(line, pos)
        }
    }
    /*
    https://stackoverflow.com/questions/9907419/how-to-get-a-key-in-a-javascript-object-by-its-value
    */
    getTokenType(value) {
        return Object.keys(TokenType).find(key => TokenType[key] === value)
    }
    printToken(t) {
        let result = ("     " + t.line).substr(t.line.toString().length)
        result += ("       " + t.pos).substr(t.pos.toString().length)
        result += (" " + this.getTokenType(t.type) + "           ").substr(0, 16)
        switch (t.type) {
            case TokenType.Integer:
                result += "  " + t.value
                break;
            case TokenType.Identifier:
                result += " " + t.value
                break;
            case TokenType.String:
                result += " \""+ t.value + "\""
                break;
        }
        console.log(result)
    }
    printTokens() {
        let t
        while ((t = this.getToken()).type !== TokenType.End_of_input) {
            this.printToken(t)
        }
        this.printToken(t)
    }
}
const fs = require("fs")
fs.readFile(process.argv[2], "utf8", (err, data) => {
    l = new Lexer(data)
    l.printTokens()
})
