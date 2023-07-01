package main

import (
    "bufio"
    "encoding/binary"
    "fmt"
    "log"
    "os"
    "strconv"
    "strings"
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

type code = byte

const (
    fetch code = iota
    store
    push
    add
    sub
    mul
    div
    mod
    lt
    gt
    le
    ge
    eq
    ne
    and
    or
    neg
    not
    jmp
    jz
    prtc
    prts
    prti
    halt
)

type Tree struct {
    nodeType NodeType
    left     *Tree
    right    *Tree
    value    string
}

// dependency: Ordered by NodeType, must remain in same order as NodeType enum
type atr struct {
    enumText string
    nodeType NodeType
    opcode   code
}

var atrs = []atr{
    {"Identifier", ndIdent, 255},
    {"String", ndString, 255},
    {"Integer", ndInteger, 255},
    {"Sequence", ndSequence, 255},
    {"If", ndIf, 255},
    {"Prtc", ndPrtc, 255},
    {"Prts", ndPrts, 255},
    {"Prti", ndPrti, 255},
    {"While", ndWhile, 255},
    {"Assign", ndAssign, 255},
    {"Negate", ndNegate, neg},
    {"Not", ndNot, not},
    {"Multiply", ndMul, mul},
    {"Divide", ndDiv, div},
    {"Mod", ndMod, mod},
    {"Add", ndAdd, add},
    {"Subtract", ndSub, sub},
    {"Less", ndLss, lt},
    {"LessEqual", ndLeq, le},
    {"Greater", ndGtr, gt},
    {"GreaterEqual", ndGeq, ge},
    {"Equal", ndEql, eq},
    {"NotEqual", ndNeq, ne},
    {"And", ndAnd, and},
    {"Or", ndOr, or},
}

var (
    stringPool []string
    globals    []string
    object     []code
)

var (
    err     error
    scanner *bufio.Scanner
)

func reportError(msg string) {
    log.Fatalf("error : %s\n", msg)
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func nodeType2Op(nodeType NodeType) code {
    return atrs[nodeType].opcode
}

func makeNode(nodeType NodeType, left *Tree, right *Tree) *Tree {
    return &Tree{nodeType, left, right, ""}
}

func makeLeaf(nodeType NodeType, value string) *Tree {
    return &Tree{nodeType, nil, nil, value}
}

/*** Code generator ***/

func emitByte(c code) {
    object = append(object, c)
}

func emitWord(n int) {
    bs := make([]byte, 4)
    binary.LittleEndian.PutUint32(bs, uint32(n))
    for _, b := range bs {
        emitByte(code(b))
    }
}

func emitWordAt(at, n int) {
    bs := make([]byte, 4)
    binary.LittleEndian.PutUint32(bs, uint32(n))
    for i := at; i < at+4; i++ {
        object[i] = code(bs[i-at])
    }
}

func hole() int {
    t := len(object)
    emitWord(0)
    return t
}

func fetchVarOffset(id string) int {
    for i := 0; i < len(globals); i++ {
        if globals[i] == id {
            return i
        }
    }
    globals = append(globals, id)
    return len(globals) - 1
}

func fetchStringOffset(st string) int {
    for i := 0; i < len(stringPool); i++ {
        if stringPool[i] == st {
            return i
        }
    }
    stringPool = append(stringPool, st)
    return len(stringPool) - 1
}

func codeGen(x *Tree) {
    if x == nil {
        return
    }
    var n, p1, p2 int
    switch x.nodeType {
    case ndIdent:
        emitByte(fetch)
        n = fetchVarOffset(x.value)
        emitWord(n)
    case ndInteger:
        emitByte(push)
        n, err = strconv.Atoi(x.value)
        check(err)
        emitWord(n)
    case ndString:
        emitByte(push)
        n = fetchStringOffset(x.value)
        emitWord(n)
    case ndAssign:
        n = fetchVarOffset(x.left.value)
        codeGen(x.right)
        emitByte(store)
        emitWord(n)
    case ndIf:
        codeGen(x.left)       // if expr
        emitByte(jz)          // if false, jump
        p1 = hole()           // make room forjump dest
        codeGen(x.right.left) // if true statements
        if x.right.right != nil {
            emitByte(jmp)
            p2 = hole()
        }
        emitWordAt(p1, len(object)-p1)
        if x.right.right != nil {
            codeGen(x.right.right)
            emitWordAt(p2, len(object)-p2)
        }
    case ndWhile:
        p1 = len(object)
        codeGen(x.left)                // while expr
        emitByte(jz)                   // if false, jump
        p2 = hole()                    // make room for jump dest
        codeGen(x.right)               // statements
        emitByte(jmp)                  // back to the top
        emitWord(p1 - len(object))     // plug the top
        emitWordAt(p2, len(object)-p2) // plug the 'if false, jump'
    case ndSequence:
        codeGen(x.left)
        codeGen(x.right)
    case ndPrtc:
        codeGen(x.left)
        emitByte(prtc)
    case ndPrti:
        codeGen(x.left)
        emitByte(prti)
    case ndPrts:
        codeGen(x.left)
        emitByte(prts)
    case ndLss, ndGtr, ndLeq, ndGeq, ndEql, ndNeq,
        ndAnd, ndOr, ndSub, ndAdd, ndDiv, ndMul, ndMod:
        codeGen(x.left)
        codeGen(x.right)
        emitByte(nodeType2Op(x.nodeType))
    case ndNegate, ndNot:
        codeGen(x.left)
        emitByte(nodeType2Op(x.nodeType))
    default:
        msg := fmt.Sprintf("error in code generator - found %d, expecting operator\n", x.nodeType)
        reportError(msg)
    }
}

func codeFinish() {
    emitByte(halt)
}

func listCode() {
    fmt.Printf("Datasize: %d Strings: %d\n", len(globals), len(stringPool))
    for _, s := range stringPool {
        fmt.Println(s)
    }
    pc := 0
    for pc < len(object) {
        fmt.Printf("%5d ", pc)
        op := object[pc]
        pc++
        switch op {
        case fetch:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            fmt.Printf("fetch [%d]\n", x)
            pc += 4
        case store:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            fmt.Printf("store [%d]\n", x)
            pc += 4
        case push:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            fmt.Printf("push  %d\n", x)
            pc += 4
        case add:
            fmt.Println("add")
        case sub:
            fmt.Println("sub")
        case mul:
            fmt.Println("mul")
        case div:
            fmt.Println("div")
        case mod:
            fmt.Println("mod")
        case lt:
            fmt.Println("lt")
        case gt:
            fmt.Println("gt")
        case le:
            fmt.Println("le")
        case ge:
            fmt.Println("ge")
        case eq:
            fmt.Println("eq")
        case ne:
            fmt.Println("ne")
        case and:
            fmt.Println("and")
        case or:
            fmt.Println("or")
        case neg:
            fmt.Println("neg")
        case not:
            fmt.Println("not")
        case jmp:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            fmt.Printf("jmp    (%d) %d\n", x, int32(pc)+x)
            pc += 4
        case jz:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            fmt.Printf("jz     (%d) %d\n", x, int32(pc)+x)
            pc += 4
        case prtc:
            fmt.Println("prtc")
        case prti:
            fmt.Println("prti")
        case prts:
            fmt.Println("prts")
        case halt:
            fmt.Println("halt")
        default:
            reportError(fmt.Sprintf("listCode: Unknown opcode %d", op))
        }
    }
}

func getEnumValue(name string) NodeType {
    for _, atr := range atrs {
        if atr.enumText == name {
            return atr.nodeType
        }
    }
    reportError(fmt.Sprintf("Unknown token %s\n", name))
    return -1
}

func loadAst() *Tree {
    var nodeType NodeType
    var s string
    if scanner.Scan() {
        line := strings.TrimRight(scanner.Text(), " \t")
        tokens := strings.Fields(line)
        first := tokens[0]
        if first[0] == ';' {
            return nil
        }
        nodeType = getEnumValue(first)
        le := len(tokens)
        if le == 2 {
            s = tokens[1]
        } else if le > 2 {
            idx := strings.Index(line, `"`)
            s = line[idx:]
        }
    }
    check(scanner.Err())
    if s != "" {
        return makeLeaf(nodeType, s)
    }
    left := loadAst()
    right := loadAst()
    return makeNode(nodeType, left, right)
}

func main() {
    ast, err := os.Open("ast.txt")
    check(err)
    defer ast.Close()
    scanner = bufio.NewScanner(ast)
    codeGen(loadAst())
    codeFinish()
    listCode()
}
