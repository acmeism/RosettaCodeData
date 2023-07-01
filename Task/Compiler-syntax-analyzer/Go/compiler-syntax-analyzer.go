package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strconv"
    "strings"
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
    tkEql
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

type NodeType int

const (
    ndIdent NodeType = iota
    ndString
    ndInteger
    ndSequence
    ndIf
    ndPrtc
    ndPrts
    ndPrti
    ndWhile
    ndAssign
    ndNegate
    ndNot
    ndMul
    ndDiv
    ndMod
    ndAdd
    ndSub
    ndLss
    ndLeq
    ndGtr
    ndGeq
    ndEql
    ndNeq
    ndAnd
    ndOr
)

type tokS struct {
    tok    TokenType
    errLn  int
    errCol int
    text   string // ident or string literal or integer value
}

type Tree struct {
    nodeType NodeType
    left     *Tree
    right    *Tree
    value    string
}

// dependency: Ordered by tok, must remain in same order as TokenType consts
type atr struct {
    text             string
    enumText         string
    tok              TokenType
    rightAssociative bool
    isBinary         bool
    isUnary          bool
    precedence       int
    nodeType         NodeType
}

var atrs = []atr{
    {"EOI", "End_of_input", tkEOI, false, false, false, -1, -1},
    {"*", "Op_multiply", tkMul, false, true, false, 13, ndMul},
    {"/", "Op_divide", tkDiv, false, true, false, 13, ndDiv},
    {"%", "Op_mod", tkMod, false, true, false, 13, ndMod},
    {"+", "Op_add", tkAdd, false, true, false, 12, ndAdd},
    {"-", "Op_subtract", tkSub, false, true, false, 12, ndSub},
    {"-", "Op_negate", tkNegate, false, false, true, 14, ndNegate},
    {"!", "Op_not", tkNot, false, false, true, 14, ndNot},
    {"<", "Op_less", tkLss, false, true, false, 10, ndLss},
    {"<=", "Op_lessequal", tkLeq, false, true, false, 10, ndLeq},
    {">", "Op_greater", tkGtr, false, true, false, 10, ndGtr},
    {">=", "Op_greaterequal", tkGeq, false, true, false, 10, ndGeq},
    {"==", "Op_equal", tkEql, false, true, false, 9, ndEql},
    {"!=", "Op_notequal", tkNeq, false, true, false, 9, ndNeq},
    {"=", "Op_assign", tkAssign, false, false, false, -1, ndAssign},
    {"&&", "Op_and", tkAnd, false, true, false, 5, ndAnd},
    {"||", "Op_or", tkOr, false, true, false, 4, ndOr},
    {"if", "Keyword_if", tkIf, false, false, false, -1, ndIf},
    {"else", "Keyword_else", tkElse, false, false, false, -1, -1},
    {"while", "Keyword_while", tkWhile, false, false, false, -1, ndWhile},
    {"print", "Keyword_print", tkPrint, false, false, false, -1, -1},
    {"putc", "Keyword_putc", tkPutc, false, false, false, -1, -1},
    {"(", "LeftParen", tkLparen, false, false, false, -1, -1},
    {")", "RightParen", tkRparen, false, false, false, -1, -1},
    {"{", "LeftBrace", tkLbrace, false, false, false, -1, -1},
    {"}", "RightBrace", tkRbrace, false, false, false, -1, -1},
    {";", "Semicolon", tkSemi, false, false, false, -1, -1},
    {",", "Comma", tkComma, false, false, false, -1, -1},
    {"Ident", "Identifier", tkIdent, false, false, false, -1, ndIdent},
    {"Integer literal", "Integer", tkInteger, false, false, false, -1, ndInteger},
    {"String literal", "String", tkString, false, false, false, -1, ndString},
}

var displayNodes = []string{
    "Identifier", "String", "Integer", "Sequence", "If", "Prtc", "Prts", "Prti",
    "While", "Assign", "Negate", "Not", "Multiply", "Divide", "Mod", "Add",
    "Subtract", "Less", "LessEqual", "Greater", "GreaterEqual", "Equal",
    "NotEqual", "And", "Or",
}

var (
    err     error
    token   tokS
    scanner *bufio.Scanner
)

func reportError(errLine, errCol int, msg string) {
    log.Fatalf("(%d, %d) error : %s\n", errLine, errCol, msg)
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func getEum(name string) TokenType { // return internal version of name#
    for _, atr := range atrs {
        if atr.enumText == name {
            return atr.tok
        }
    }
    reportError(0, 0, fmt.Sprintf("Unknown token %s\n", name))
    return tkEOI
}

func getTok() tokS {
    tok := tokS{}
    if scanner.Scan() {
        line := strings.TrimRight(scanner.Text(), " \t")
        fields := strings.Fields(line)
        // [ ]*{lineno}[ ]+{colno}[ ]+token[ ]+optional
        tok.errLn, err = strconv.Atoi(fields[0])
        check(err)
        tok.errCol, err = strconv.Atoi(fields[1])
        check(err)
        tok.tok = getEum(fields[2])
        le := len(fields)
        if le == 4 {
            tok.text = fields[3]
        } else if le > 4 {
            idx := strings.Index(line, `"`)
            tok.text = line[idx:]
        }
    }
    check(scanner.Err())
    return tok
}

func makeNode(nodeType NodeType, left *Tree, right *Tree) *Tree {
    return &Tree{nodeType, left, right, ""}
}

func makeLeaf(nodeType NodeType, value string) *Tree {
    return &Tree{nodeType, nil, nil, value}
}

func expect(msg string, s TokenType) {
    if token.tok == s {
        token = getTok()
        return
    }
    reportError(token.errLn, token.errCol,
        fmt.Sprintf("%s: Expecting '%s', found '%s'\n", msg, atrs[s].text, atrs[token.tok].text))
}

func expr(p int) *Tree {
    var x, node *Tree
    switch token.tok {
    case tkLparen:
        x = parenExpr()
    case tkSub, tkAdd:
        op := token.tok
        token = getTok()
        node = expr(atrs[tkNegate].precedence)
        if op == tkSub {
            x = makeNode(ndNegate, node, nil)
        } else {
            x = node
        }
    case tkNot:
        token = getTok()
        x = makeNode(ndNot, expr(atrs[tkNot].precedence), nil)
    case tkIdent:
        x = makeLeaf(ndIdent, token.text)
        token = getTok()
    case tkInteger:
        x = makeLeaf(ndInteger, token.text)
        token = getTok()
    default:
        reportError(token.errLn, token.errCol,
            fmt.Sprintf("Expecting a primary, found: %s\n", atrs[token.tok].text))
    }

    for atrs[token.tok].isBinary && atrs[token.tok].precedence >= p {
        op := token.tok
        token = getTok()
        q := atrs[op].precedence
        if !atrs[op].rightAssociative {
            q++
        }
        node = expr(q)
        x = makeNode(atrs[op].nodeType, x, node)
    }
    return x
}

func parenExpr() *Tree {
    expect("parenExpr", tkLparen)
    t := expr(0)
    expect("parenExpr", tkRparen)
    return t
}

func stmt() *Tree {
    var t, v, e, s, s2 *Tree
    switch token.tok {
    case tkIf:
        token = getTok()
        e = parenExpr()
        s = stmt()
        s2 = nil
        if token.tok == tkElse {
            token = getTok()
            s2 = stmt()
        }
        t = makeNode(ndIf, e, makeNode(ndIf, s, s2))
    case tkPutc:
        token = getTok()
        e = parenExpr()
        t = makeNode(ndPrtc, e, nil)
        expect("Putc", tkSemi)
    case tkPrint: // print '(' expr {',' expr} ')'
        token = getTok()
        for expect("Print", tkLparen); ; expect("Print", tkComma) {
            if token.tok == tkString {
                e = makeNode(ndPrts, makeLeaf(ndString, token.text), nil)
                token = getTok()
            } else {
                e = makeNode(ndPrti, expr(0), nil)
            }
            t = makeNode(ndSequence, t, e)
            if token.tok != tkComma {
                break
            }
        }
        expect("Print", tkRparen)
        expect("Print", tkSemi)
    case tkSemi:
        token = getTok()
    case tkIdent:
        v = makeLeaf(ndIdent, token.text)
        token = getTok()
        expect("assign", tkAssign)
        e = expr(0)
        t = makeNode(ndAssign, v, e)
        expect("assign", tkSemi)
    case tkWhile:
        token = getTok()
        e = parenExpr()
        s = stmt()
        t = makeNode(ndWhile, e, s)
    case tkLbrace: // {stmt}
        for expect("Lbrace", tkLbrace); token.tok != tkRbrace && token.tok != tkEOI; {
            t = makeNode(ndSequence, t, stmt())
        }
        expect("Lbrace", tkRbrace)
    case tkEOI:
        // do nothing
    default:
        reportError(token.errLn, token.errCol,
            fmt.Sprintf("expecting start of statement, found '%s'\n", atrs[token.tok].text))
    }
    return t
}

func parse() *Tree {
    var t *Tree
    token = getTok()
    for {
        t = makeNode(ndSequence, t, stmt())
        if t == nil || token.tok == tkEOI {
            break
        }
    }
    return t
}

func prtAst(t *Tree) {
    if t == nil {
        fmt.Print(";\n")
    } else {
        fmt.Printf("%-14s ", displayNodes[t.nodeType])
        if t.nodeType == ndIdent || t.nodeType == ndInteger || t.nodeType == ndString {
            fmt.Printf("%s\n", t.value)
        } else {
            fmt.Println()
            prtAst(t.left)
            prtAst(t.right)
        }
    }
}

func main() {
    source, err := os.Open("source.txt")
    check(err)
    defer source.Close()
    scanner = bufio.NewScanner(source)
    prtAst(parse())
}
