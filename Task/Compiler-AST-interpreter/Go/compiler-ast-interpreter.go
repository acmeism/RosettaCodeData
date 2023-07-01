package main

import (
    "bufio"
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

type Tree struct {
    nodeType NodeType
    left     *Tree
    right    *Tree
    value    int
}

// dependency: Ordered by NodeType, must remain in same order as NodeType enum
type atr struct {
    enumText string
    nodeType NodeType
}

var atrs = []atr{
    {"Identifier", ndIdent},
    {"String", ndString},
    {"Integer", ndInteger},
    {"Sequence", ndSequence},
    {"If", ndIf},
    {"Prtc", ndPrtc},
    {"Prts", ndPrts},
    {"Prti", ndPrti},
    {"While", ndWhile},
    {"Assign", ndAssign},
    {"Negate", ndNegate},
    {"Not", ndNot},
    {"Multiply", ndMul},
    {"Divide", ndDiv},
    {"Mod", ndMod},
    {"Add", ndAdd},
    {"Subtract", ndSub},
    {"Less", ndLss},
    {"LessEqual", ndLeq},
    {"Greater", ndGtr},
    {"GreaterEqual", ndGeq},
    {"Equal", ndEql},
    {"NotEqual", ndNeq},
    {"And", ndAnd},
    {"Or", ndOr},
}

var (
    stringPool   []string
    globalNames  []string
    globalValues = make(map[int]int)
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

func btoi(b bool) int {
    if b {
        return 1
    }
    return 0
}

func itob(i int) bool {
    if i == 0 {
        return false
    }
    return true
}

func makeNode(nodeType NodeType, left *Tree, right *Tree) *Tree {
    return &Tree{nodeType, left, right, 0}
}

func makeLeaf(nodeType NodeType, value int) *Tree {
    return &Tree{nodeType, nil, nil, value}
}

func interp(x *Tree) int { // interpret the parse tree
    if x == nil {
        return 0
    }
    switch x.nodeType {
    case ndInteger:
        return x.value
    case ndIdent:
        return globalValues[x.value]
    case ndString:
        return x.value
    case ndAssign:
        n := interp(x.right)
        globalValues[x.left.value] = n
        return n
    case ndAdd:
        return interp(x.left) + interp(x.right)
    case ndSub:
        return interp(x.left) - interp(x.right)
    case ndMul:
        return interp(x.left) * interp(x.right)
    case ndDiv:
        return interp(x.left) / interp(x.right)
    case ndMod:
        return interp(x.left) % interp(x.right)
    case ndLss:
        return btoi(interp(x.left) < interp(x.right))
    case ndGtr:
        return btoi(interp(x.left) > interp(x.right))
    case ndLeq:
        return btoi(interp(x.left) <= interp(x.right))
    case ndEql:
        return btoi(interp(x.left) == interp(x.right))
    case ndNeq:
        return btoi(interp(x.left) != interp(x.right))
    case ndAnd:
        return btoi(itob(interp(x.left)) && itob(interp(x.right)))
    case ndOr:
        return btoi(itob(interp(x.left)) || itob(interp(x.right)))
    case ndNegate:
        return -interp(x.left)
    case ndNot:
        if interp(x.left) == 0 {
            return 1
        }
        return 0
    case ndIf:
        if interp(x.left) != 0 {
            interp(x.right.left)
        } else {
            interp(x.right.right)
        }
        return 0
    case ndWhile:
        for interp(x.left) != 0 {
            interp(x.right)
        }
        return 0
    case ndPrtc:
        fmt.Printf("%c", interp(x.left))
        return 0
    case ndPrti:
        fmt.Printf("%d", interp(x.left))
        return 0
    case ndPrts:
        fmt.Print(stringPool[interp(x.left)])
        return 0
    case ndSequence:
        interp(x.left)
        interp(x.right)
        return 0
    default:
        reportError(fmt.Sprintf("interp: unknown tree type %d\n", x.nodeType))
    }
    return 0
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

func fetchStringOffset(s string) int {
    var d strings.Builder
    s = s[1 : len(s)-1]
    for i := 0; i < len(s); i++ {
        if s[i] == '\\' && (i+1) < len(s) {
            if s[i+1] == 'n' {
                d.WriteByte('\n')
                i++
            } else if s[i+1] == '\\' {
                d.WriteByte('\\')
                i++
            }
        } else {
            d.WriteByte(s[i])
        }
    }
    s = d.String()
    for i := 0; i < len(stringPool); i++ {
        if s == stringPool[i] {
            return i
        }
    }
    stringPool = append(stringPool, s)
    return len(stringPool) - 1
}

func fetchVarOffset(name string) int {
    for i := 0; i < len(globalNames); i++ {
        if globalNames[i] == name {
            return i
        }
    }
    globalNames = append(globalNames, name)
    return len(globalNames) - 1
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
        var n int
        switch nodeType {
        case ndIdent:
            n = fetchVarOffset(s)
        case ndInteger:
            n, err = strconv.Atoi(s)
            check(err)
        case ndString:
            n = fetchStringOffset(s)
        default:
            reportError(fmt.Sprintf("Unknown node type: %s\n", s))
        }
        return makeLeaf(nodeType, n)
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
    x := loadAst()
    interp(x)
}
