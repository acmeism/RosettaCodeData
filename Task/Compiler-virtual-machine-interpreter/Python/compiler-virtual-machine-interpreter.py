from __future__ import print_function
import sys, struct

FETCH, STORE, PUSH, ADD, SUB, MUL, DIV, MOD, LT, GT, LE, GE, EQ, NE, AND, OR, NEG, NOT, \
JMP, JZ, PRTC, PRTS, PRTI, HALT = range(24)

code_map = {
    "fetch": FETCH,
    "store": STORE,
    "push":  PUSH,
    "add":   ADD,
    "sub":   SUB,
    "mul":   MUL,
    "div":   DIV,
    "mod":   MOD,
    "lt":    LT,
    "gt":    GT,
    "le":    LE,
    "ge":    GE,
    "eq":    EQ,
    "ne":    NE,
    "and":   AND,
    "or":    OR,
    "not":   NOT,
    "neg":   NEG,
    "jmp":   JMP,
    "jz":    JZ,
    "prtc":  PRTC,
    "prts":  PRTS,
    "prti":  PRTI,
    "halt":  HALT
}

input_file  = None
code        = bytearray()
string_pool = []
word_size   = 4

#*** show error and exit
def error(msg):
    print("%s" % (msg))
    exit(1)

def int_to_bytes(val):
    return struct.pack("<i", val)

def bytes_to_int(bstr):
    return struct.unpack("<i", bstr)

#***
def emit_byte(x):
    code.append(x)

#***
def emit_word(x):
    s = int_to_bytes(x)
    for x in s:
        code.append(x)

#***
def run_vm(data_size):
    stack = [0 for i in range(data_size + 1)]
    pc = 0
    while True:
        op = code[pc]
        pc += 1

        if op == FETCH:
            stack.append(stack[bytes_to_int(code[pc:pc+word_size])[0]]);
            pc += word_size
        elif op == STORE:
            stack[bytes_to_int(code[pc:pc+word_size])[0]] = stack.pop();
            pc += word_size
        elif op == PUSH:
            stack.append(bytes_to_int(code[pc:pc+word_size])[0]);
            pc += word_size
        elif op == ADD:   stack[-2] += stack[-1]; stack.pop()
        elif op == SUB:   stack[-2] -= stack[-1]; stack.pop()
        elif op == MUL:   stack[-2] *= stack[-1]; stack.pop()
        # use C like division semantics
        elif op == DIV:   stack[-2] = int(float(stack[-2]) / stack[-1]); stack.pop()
        elif op == MOD:   stack[-2] = int(float(stack[-2]) % stack[-1]); stack.pop()
        elif op == LT:    stack[-2] = stack[-2] <  stack[-1]; stack.pop()
        elif op == GT:    stack[-2] = stack[-2] >  stack[-1]; stack.pop()
        elif op == LE:    stack[-2] = stack[-2] <= stack[-1]; stack.pop()
        elif op == GE:    stack[-2] = stack[-2] >= stack[-1]; stack.pop()
        elif op == EQ:    stack[-2] = stack[-2] == stack[-1]; stack.pop()
        elif op == NE:    stack[-2] = stack[-2] != stack[-1]; stack.pop()
        elif op == AND:   stack[-2] = stack[-2] and stack[-1]; stack.pop()
        elif op == OR:    stack[-2] = stack[-2] or  stack[-1]; stack.pop()
        elif op == NEG:   stack[-1] = -stack[-1]
        elif op == NOT:   stack[-1] = not stack[-1]
        elif op == JMP:   pc += bytes_to_int(code[pc:pc+word_size])[0]
        elif op == JZ:
            if stack.pop():
                pc += word_size
            else:
                pc += bytes_to_int(code[pc:pc+word_size])[0]
        elif op == PRTC:  print("%c" % (stack[-1]), end=''); stack.pop()
        elif op == PRTS:  print("%s" % (string_pool[stack[-1]]), end=''); stack.pop()
        elif op == PRTI:  print("%d" % (stack[-1]), end=''); stack.pop()
        elif op == HALT:  break

def str_trans(srce):
    dest = ""
    i = 0
    while i < len(srce):
        if srce[i] == '\\' and i + 1 < len(srce):
            if srce[i + 1] == 'n':
                dest += '\n'
                i += 2
            elif srce[i + 1] == '\\':
                dest += '\\'
                i += 2
        else:
            dest += srce[i]
            i += 1

    return dest

#***
def load_code():
    global string_pool

    line = input_file.readline()
    if len(line) == 0:
        error("empty line")

    line_list = line.split()
    data_size = int(line_list[1])
    n_strings = int(line_list[3])

    for i in range(n_strings):
        string_pool.append(str_trans(input_file.readline().strip('"\n')))

    while True:
        line = input_file.readline()
        if len(line) == 0:
            break
        line_list = line.split()
        offset = int(line_list[0])
        instr  = line_list[1]
        opcode = code_map.get(instr)
        if opcode == None:
            error("Unknown instruction %s at %d" % (instr, offset))
        emit_byte(opcode)
        if opcode in [JMP, JZ]:
            p = int(line_list[3])
            emit_word(p - (offset + 1))
        elif opcode == PUSH:
            value = int(line_list[2])
            emit_word(value)
        elif opcode in [FETCH, STORE]:
            value = int(line_list[2].strip('[]'))
            emit_word(value)

    return data_size

#*** main driver
input_file = sys.stdin
if len(sys.argv) > 1:
    try:
        input_file = open(sys.argv[1], "r", 4096)
    except IOError as e:
        error(0, 0, "Can't open %s" % sys.argv[1])

data_size = load_code()
run_vm(data_size)
