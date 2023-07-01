package main

import (
	"bufio"
	"fmt"
	"io"
	"regexp"
	"strconv"
	"strings"
)

const (
	NOP = iota
	LDA
	STA
	ADD
	SUB
	BRZ
	JMP
	STP
)

var opcodes = map[string]int{
	"NOP": NOP,
	"LDA": LDA,
	"STA": STA,
	"ADD": ADD,
	"SUB": SUB,
	"BRZ": BRZ,
	"JMP": JMP,
	"STP": STP,
}

var reIns = regexp.MustCompile(
	`\s*(?:(\w+):)?\s*` + // label
		`(NOP|LDA|STA|ADD|SUB|BRZ|JMP|STP)?\s*` + // opcode
		`(\w+)?\s*` + // argument
		`(?:;([\w\s]+))?`) // comment

type ByteCode [32]int

type instruction struct {
	Label  string
	Opcode string
	Arg    string
}

type Program struct {
	Instructions []instruction
	Labels       map[string]int
}

func newInstruction(line string) (*instruction, error) {
	match := reIns.FindStringSubmatch(line)
	if match == nil {
		return nil, fmt.Errorf("syntax error: '%s'", line)
	}
	return &instruction{Label: match[1], Opcode: match[2], Arg: match[3]}, nil
}

func Parse(asm io.Reader) (*Program, error) {
	var p Program
	p.Labels = make(map[string]int, 32)
	scanner := bufio.NewScanner(asm)
	lineNumber := 0

	for scanner.Scan() {
		if instruction, err := newInstruction(scanner.Text()); err != nil {
			return &p, err
		} else {
			if instruction.Label != "" {
				p.Labels[instruction.Label] = lineNumber
			}
			p.Instructions = append(p.Instructions, *instruction)
			lineNumber++
		}
	}

	if err := scanner.Err(); err != nil {
		return nil, err
	}

	return &p, nil
}

func (p *Program) Compile() (ByteCode, error) {
	var bytecode ByteCode
	var arg int
	for i, ins := range p.Instructions {
		if ins.Arg == "" {
			arg = 0
		} else if addr, err := strconv.Atoi(ins.Arg); err == nil {
			arg = addr
		} else if addr, ok := p.Labels[ins.Arg]; ok {
			arg = addr
		} else {
			return bytecode, fmt.Errorf("unknown label %v", ins.Arg)
		}

		if opcode, ok := opcodes[ins.Opcode]; ok {
			bytecode[i] = opcode<<5 | arg
		} else {
			bytecode[i] = arg
		}
	}
	return bytecode, nil
}

func floorMod(a, b int) int {
	return ((a % b) + b) % b
}

func Run(bytecode ByteCode) (int, error) {
	acc := 0
	pc := 0
	mem := bytecode

	var op int
	var arg int

loop:
	for pc < 32 {
		op = mem[pc] >> 5
		arg = mem[pc] & 31
		pc++

		switch op {
		case NOP:
			continue
		case LDA:
			acc = mem[arg]
		case STA:
			mem[arg] = acc
		case ADD:
			acc = floorMod(acc+mem[arg], 256)
		case SUB:
			acc = floorMod(acc-mem[arg], 256)
		case BRZ:
			if acc == 0 {
				pc = arg
			}
		case JMP:
			pc = arg
		case STP:
			break loop
		default:
			return acc, fmt.Errorf("runtime error: %v %v", op, arg)
		}
	}

	return acc, nil
}

func Execute(asm string) (int, error) {
	program, err := Parse(strings.NewReader(asm))
	if err != nil {
		return 0, fmt.Errorf("assembly error: %v", err)
	}

	bytecode, err := program.Compile()
	if err != nil {
		return 0, fmt.Errorf("compilation error: %v", err)
	}

	result, err := Run(bytecode)
	if err != nil {
		return 0, err
	}

	return result, nil
}

func main() {
	examples := []string{
		`LDA   x
		ADD   y       ; accumulator = x + y
		STP
x:            2
y:            2`,
		`loop:   LDA   prodt
	ADD   x
	STA   prodt
	LDA   y
	SUB   one
	STA   y
	BRZ   done
	JMP   loop
done:   LDA   prodt   ; to display it
	STP
x:            8
y:            7
prodt:        0
one:          1`,
		`loop:   LDA   n
	STA   temp
	ADD   m
	STA   n
	LDA   temp
	STA   m
	LDA   count
	SUB   one
	BRZ   done
	STA   count
	JMP   loop
done:   LDA   n       ; to display it
	STP
m:            1
n:            1
temp:         0
count:        8       ; valid range: 1-11
one:          1`,
		`start:  LDA   load
ADD   car     ; head of list
STA   ldcar
ADD   one
STA   ldcdr   ; next CONS cell
ldcar:  NOP
STA   value
ldcdr:  NOP
BRZ   done    ; 0 stands for NIL
STA   car
JMP   start
done:   LDA   value   ; CAR of last CONS
STP
load:   LDA   0
value:        0
car:          28
one:          1
			; order of CONS cells
			; in memory
			; does not matter
	6
	0       ; 0 stands for NIL
	2       ; (CADR ls)
	26      ; (CDDR ls) -- etc.
	5
	20
	3
	30
	1       ; value of (CAR ls)
	22      ; points to (CDR ls)
	4
	24`,
		`LDA  3
SUB  4
STP  0
	 0
	 255`,
		`LDA  3
SUB  4
STP  0
		0
		1`,
		`LDA  3
ADD  4
STP  0
		1
		255`,
	}

	for _, asm := range examples {
		if result, err := Execute(asm); err == nil {
			fmt.Println(result)
		} else {
			fmt.Println(err)
		}
	}
}
