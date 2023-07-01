package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
)

type TokenType int

const (
    tkEOI TokenType = iota
    tkMul
    tkDiv
    tkMod
    tkAdd
    tkSub
    tkNegate
    tkNot
    tkLss
    tkLeq
    tkGtr
    tkGeq
    tkEq
    tkNeq
    tkAssign
    tkAnd
    tkOr
    tkIf
    tkElse
    tkWhile
    tkPrint
    tkPutc
    tkLparen
    tkRparen
    tkLbrace
    tkRbrace
    tkSemi
    tkComma
    tkIdent
    tkInteger
    tkString
)

type Symbol struct {
    name string
    tok  TokenType
}

// symbol table
var symtab []Symbol

var scanner *bufio.Scanner

var (
    curLine = ""
    curCh   byte
    lineNum = 0
    colNum  = 0
)

const etx byte = 4 // used to signify EOI

func isDigit(ch byte) bool {
    return ch >= '0' && ch <= '9'
}

func isAlnum(ch byte) bool {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || isDigit(ch)
}

func errorMsg(eline, ecol int, msg string) {
    log.Fatalf("(%d:%d) %s", eline, ecol, msg)
}

// add an identifier to the symbol table
func install(name string, tok TokenType) {
    sym := Symbol{name, tok}
    symtab = append(symtab, sym)
}

// search for an identifier in the symbol table
func lookup(name string) int {
    for i := 0; i < len(symtab); i++ {
        if symtab[i].name == name {
            return i
        }
    }
    return -1
}

// read the next line of input from the source file
func nextLine() {
    if scanner.Scan() {
        curLine = scanner.Text()
        lineNum++
        colNum = 0
        if curLine == "" { // skip blank lines
            nextLine()
        }
    } else {
        err := scanner.Err()
        if err == nil { // EOF
            curCh = etx
            curLine = ""
            lineNum++
            colNum = 1
        } else {
            log.Fatal(err)
        }
    }
}

// get the next char
func nextChar() {
    if colNum >= len(curLine) {
        nextLine()
    }
    if colNum < len(curLine) {
        curCh = curLine[colNum]
        colNum++
    }
}

func follow(eline, ecol int, expect byte, ifyes, ifno TokenType) TokenType {
    if curCh == expect {
        nextChar()
        return ifyes
    }
    if ifno == tkEOI {
        errorMsg(eline, ecol, "follow unrecognized character: "+string(curCh))
    }
    return ifno
}

func gettok() (eline, ecol int, tok TokenType, v string) {
    // skip whitespace
    for curCh == ' ' || curCh == '\t' || curCh == '\n' {
        nextChar()
    }
    eline = lineNum
    ecol = colNum
    switch curCh {
    case etx:
        tok = tkEOI
        return
    case '{':
        tok = tkLbrace
        nextChar()
        return
    case '}':
        tok = tkRbrace
        nextChar()
        return
    case '(':
        tok = tkLparen
        nextChar()
        return
    case ')':
        tok = tkRparen
        nextChar()
        return
    case '+':
        tok = tkAdd
        nextChar()
        return
    case '-':
        tok = tkSub
        nextChar()
        return
    case '*':
        tok = tkMul
        nextChar()
        return
    case '%':
        tok = tkMod
        nextChar()
        return
    case ';':
        tok = tkSemi
        nextChar()
        return
    case ',':
        tok = tkComma
        nextChar()
        return
    case '/': // div or comment
        nextChar()
        if curCh != '*' {
            tok = tkDiv
            return
        }
        // skip comments
        nextChar()
        for {
            if curCh == '*' {
                nextChar()
                if curCh == '/' {
                    nextChar()
                    eline, ecol, tok, v = gettok()
                    return
                }
            } else if curCh == etx {
                errorMsg(eline, ecol, "EOF in comment")
            } else {
                nextChar()
            }
        }
    case '\'': // single char literals
        nextChar()
        v = fmt.Sprintf("%d", curCh)
        if curCh == '\'' {
            errorMsg(eline, ecol, "Empty character constant")
        }
        if curCh == '\\' {
            nextChar()
            if curCh == 'n' {
                v = "10"
            } else if curCh == '\\' {
                v = "92"
            } else {
                errorMsg(eline, ecol, "unknown escape sequence: "+string(curCh))
            }
        }
        nextChar()
        if curCh != '\'' {
            errorMsg(eline, ecol, "multi-character constant")
        }
        nextChar()
        tok = tkInteger
        return
    case '<':
        nextChar()
        tok = follow(eline, ecol, '=', tkLeq, tkLss)
        return
    case '>':
        nextChar()
        tok = follow(eline, ecol, '=', tkGeq, tkGtr)
        return
    case '!':
        nextChar()
        tok = follow(eline, ecol, '=', tkNeq, tkNot)
        return
    case '=':
        nextChar()
        tok = follow(eline, ecol, '=', tkEq, tkAssign)
        return
    case '&':
        nextChar()
        tok = follow(eline, ecol, '&', tkAnd, tkEOI)
        return
    case '|':
        nextChar()
        tok = follow(eline, ecol, '|', tkOr, tkEOI)
        return
    case '"': // string
        v = string(curCh)
        nextChar()
        for curCh != '"' {
            if curCh == '\n' {
                errorMsg(eline, ecol, "EOL in string")
            }
            if curCh == etx {
                errorMsg(eline, ecol, "EOF in string")
            }
            v += string(curCh)
            nextChar()
        }
        v += string(curCh)
        nextChar()
        tok = tkString
        return
    default: // integers or identifiers
        isNumber := isDigit(curCh)
        v = ""
        for isAlnum(curCh) || curCh == '_' {
            if !isDigit(curCh) {
                isNumber = false
            }
            v += string(curCh)
            nextChar()
        }
        if len(v) == 0 {
            errorMsg(eline, ecol, "unknown character: "+string(curCh))
        }
        if isDigit(v[0]) {
            if !isNumber {
                errorMsg(eline, ecol, "invalid number: "+string(curCh))
            }
            tok = tkInteger
            return
        }
        index := lookup(v)
        if index == -1 {
            tok = tkIdent
        } else {
            tok = symtab[index].tok
        }
        return
    }
}

func initLex() {
    install("else", tkElse)
    install("if", tkIf)
    install("print", tkPrint)
    install("putc", tkPutc)
    install("while", tkWhile)
    nextChar()
}

func process() {
    tokMap := make(map[TokenType]string)
    tokMap[tkEOI] = "End_of_input"
    tokMap[tkMul] = "Op_multiply"
    tokMap[tkDiv] = "Op_divide"
    tokMap[tkMod] = "Op_mod"
    tokMap[tkAdd] = "Op_add"
    tokMap[tkSub] = "Op_subtract"
    tokMap[tkNegate] = "Op_negate"
    tokMap[tkNot] = "Op_not"
    tokMap[tkLss] = "Op_less"
    tokMap[tkLeq] = "Op_lessequal"
    tokMap[tkGtr] = "Op_greater"
    tokMap[tkGeq] = "Op_greaterequal"
    tokMap[tkEq] = "Op_equal"
    tokMap[tkNeq] = "Op_notequal"
    tokMap[tkAssign] = "Op_assign"
    tokMap[tkAnd] = "Op_and"
    tokMap[tkOr] = "Op_or"
    tokMap[tkIf] = "Keyword_if"
    tokMap[tkElse] = "Keyword_else"
    tokMap[tkWhile] = "Keyword_while"
    tokMap[tkPrint] = "Keyword_print"
    tokMap[tkPutc] = "Keyword_putc"
    tokMap[tkLparen] = "LeftParen"
    tokMap[tkRparen] = "RightParen"
    tokMap[tkLbrace] = "LeftBrace"
    tokMap[tkRbrace] = "RightBrace"
    tokMap[tkSemi] = "Semicolon"
    tokMap[tkComma] = "Comma"
    tokMap[tkIdent] = "Identifier"
    tokMap[tkInteger] = "Integer"
    tokMap[tkString] = "String"

    for {
        eline, ecol, tok, v := gettok()
        fmt.Printf("%5d  %5d %-16s", eline, ecol, tokMap[tok])
        if tok == tkInteger || tok == tkIdent || tok == tkString {
            fmt.Println(v)
        } else {
            fmt.Println()
        }
        if tok == tkEOI {
            return
        }
    }
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    if len(os.Args) < 2 {
        fmt.Println("Filename required")
        return
    }
    f, err := os.Open(os.Args[1])
    check(err)
    defer f.Close()
    scanner = bufio.NewScanner(f)
    initLex()
    process()
}
