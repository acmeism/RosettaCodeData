package main

import (
    "bufio"
    "encoding/binary"
    "fmt"
    "log"
    "math"
    "os"
    "strconv"
    "strings"
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

var codeMap = map[string]code{
    "fetch": fetch,
    "store": store,
    "push":  push,
    "add":   add,
    "sub":   sub,
    "mul":   mul,
    "div":   div,
    "mod":   mod,
    "lt":    lt,
    "gt":    gt,
    "le":    le,
    "ge":    ge,
    "eq":    eq,
    "ne":    ne,
    "and":   and,
    "or":    or,
    "neg":   neg,
    "not":   not,
    "jmp":   jmp,
    "jz":    jz,
    "prtc":  prtc,
    "prts":  prts,
    "prti":  prti,
    "halt":  halt,
}

var (
    err        error
    scanner    *bufio.Scanner
    object     []code
    stringPool []string
)

func reportError(msg string) {
    log.Fatalf("error : %s\n", msg)
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func btoi(b bool) int32 {
    if b {
        return 1
    }
    return 0
}

func itob(i int32) bool {
    if i != 0 {
        return true
    }
    return false
}

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

/*** Virtual Machine interpreter ***/
func runVM(dataSize int) {
    stack := make([]int32, dataSize+1)
    pc := int32(0)
    for {
        op := object[pc]
        pc++
        switch op {
        case fetch:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            stack = append(stack, stack[x])
            pc += 4
        case store:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            ln := len(stack)
            stack[x] = stack[ln-1]
            stack = stack[:ln-1]
            pc += 4
        case push:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            stack = append(stack, x)
            pc += 4
        case add:
            ln := len(stack)
            stack[ln-2] += stack[ln-1]
            stack = stack[:ln-1]
        case sub:
            ln := len(stack)
            stack[ln-2] -= stack[ln-1]
            stack = stack[:ln-1]
        case mul:
            ln := len(stack)
            stack[ln-2] *= stack[ln-1]
            stack = stack[:ln-1]
        case div:
            ln := len(stack)
            stack[ln-2] = int32(float64(stack[ln-2]) / float64(stack[ln-1]))
            stack = stack[:ln-1]
        case mod:
            ln := len(stack)
            stack[ln-2] = int32(math.Mod(float64(stack[ln-2]), float64(stack[ln-1])))
            stack = stack[:ln-1]
        case lt:
            ln := len(stack)
            stack[ln-2] = btoi(stack[ln-2] < stack[ln-1])
            stack = stack[:ln-1]
        case gt:
            ln := len(stack)
            stack[ln-2] = btoi(stack[ln-2] > stack[ln-1])
            stack = stack[:ln-1]
        case le:
            ln := len(stack)
            stack[ln-2] = btoi(stack[ln-2] <= stack[ln-1])
            stack = stack[:ln-1]
        case ge:
            ln := len(stack)
            stack[ln-2] = btoi(stack[ln-2] >= stack[ln-1])
            stack = stack[:ln-1]
        case eq:
            ln := len(stack)
            stack[ln-2] = btoi(stack[ln-2] == stack[ln-1])
            stack = stack[:ln-1]
        case ne:
            ln := len(stack)
            stack[ln-2] = btoi(stack[ln-2] != stack[ln-1])
            stack = stack[:ln-1]
        case and:
            ln := len(stack)
            stack[ln-2] = btoi(itob(stack[ln-2]) && itob(stack[ln-1]))
            stack = stack[:ln-1]
        case or:
            ln := len(stack)
            stack[ln-2] = btoi(itob(stack[ln-2]) || itob(stack[ln-1]))
            stack = stack[:ln-1]
        case neg:
            ln := len(stack)
            stack[ln-1] = -stack[ln-1]
        case not:
            ln := len(stack)
            stack[ln-1] = btoi(!itob(stack[ln-1]))
        case jmp:
            x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
            pc += x
        case jz:
            ln := len(stack)
            v := stack[ln-1]
            stack = stack[:ln-1]
            if v != 0 {
                pc += 4
            } else {
                x := int32(binary.LittleEndian.Uint32(object[pc : pc+4]))
                pc += x
            }
        case prtc:
            ln := len(stack)
            fmt.Printf("%c", stack[ln-1])
            stack = stack[:ln-1]
        case prts:
            ln := len(stack)
            fmt.Printf("%s", stringPool[stack[ln-1]])
            stack = stack[:ln-1]
        case prti:
            ln := len(stack)
            fmt.Printf("%d", stack[ln-1])
            stack = stack[:ln-1]
        case halt:
            return
        default:
            reportError(fmt.Sprintf("Unknown opcode %d\n", op))
        }
    }
}

func translate(s string) string {
    var d strings.Builder
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
    return d.String()
}

func loadCode() int {
    var dataSize int
    firstLine := true
    for scanner.Scan() {
        line := strings.TrimRight(scanner.Text(), " \t")
        if len(line) == 0 {
            if firstLine {
                reportError("empty line")
            } else {
                break
            }
        }
        lineList := strings.Fields(line)
        if firstLine {
            dataSize, err = strconv.Atoi(lineList[1])
            check(err)
            nStrings, err := strconv.Atoi(lineList[3])
            check(err)
            for i := 0; i < nStrings; i++ {
                scanner.Scan()
                s := strings.Trim(scanner.Text(), "\"\n")
                stringPool = append(stringPool, translate(s))
            }
            firstLine = false
            continue
        }
        offset, err := strconv.Atoi(lineList[0])
        check(err)
        instr := lineList[1]
        opCode, ok := codeMap[instr]
        if !ok {
            reportError(fmt.Sprintf("Unknown instruction %s at %d", instr, opCode))
        }
        emitByte(opCode)
        switch opCode {
        case jmp, jz:
            p, err := strconv.Atoi(lineList[3])
            check(err)
            emitWord(p - offset - 1)
        case push:
            value, err := strconv.Atoi(lineList[2])
            check(err)
            emitWord(value)
        case fetch, store:
            value, err := strconv.Atoi(strings.Trim(lineList[2], "[]"))
            check(err)
            emitWord(value)
        }
    }
    check(scanner.Err())
    return dataSize
}

func main() {
    codeGen, err := os.Open("codegen.txt")
    check(err)
    defer codeGen.Close()
    scanner = bufio.NewScanner(codeGen)
    runVM(loadCode())
}
