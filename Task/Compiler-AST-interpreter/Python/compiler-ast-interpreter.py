from __future__ import print_function
import sys, shlex, operator

nd_Ident, nd_String, nd_Integer, nd_Sequence, nd_If, nd_Prtc, nd_Prts, nd_Prti, nd_While, \
nd_Assign, nd_Negate, nd_Not, nd_Mul, nd_Div, nd_Mod, nd_Add, nd_Sub, nd_Lss, nd_Leq,     \
nd_Gtr, nd_Geq, nd_Eql, nd_Neq, nd_And, nd_Or = range(25)

all_syms = {
    "Identifier"  : nd_Ident,    "String"      : nd_String,
    "Integer"     : nd_Integer,  "Sequence"    : nd_Sequence,
    "If"          : nd_If,       "Prtc"        : nd_Prtc,
    "Prts"        : nd_Prts,     "Prti"        : nd_Prti,
    "While"       : nd_While,    "Assign"      : nd_Assign,
    "Negate"      : nd_Negate,   "Not"         : nd_Not,
    "Multiply"    : nd_Mul,      "Divide"      : nd_Div,
    "Mod"         : nd_Mod,      "Add"         : nd_Add,
    "Subtract"    : nd_Sub,      "Less"        : nd_Lss,
    "LessEqual"   : nd_Leq,      "Greater"     : nd_Gtr,
    "GreaterEqual": nd_Geq,      "Equal"       : nd_Eql,
    "NotEqual"    : nd_Neq,      "And"         : nd_And,
    "Or"          : nd_Or}

input_file  = None
globals     = {}

#*** show error and exit
def error(msg):
    print("%s" % (msg))
    exit(1)

class Node:
    def __init__(self, node_type, left = None, right = None, value = None):
        self.node_type  = node_type
        self.left  = left
        self.right = right
        self.value = value

#***
def make_node(oper, left, right = None):
    return Node(oper, left, right)

#***
def make_leaf(oper, n):
    return Node(oper, value = n)

#***
def fetch_var(var_name):
    n = globals.get(var_name, None)
    if n == None:
        globals[var_name] = n = 0
    return n

#***
def interp(x):
    global globals

    if x == None: return None
    elif x.node_type == nd_Integer: return int(x.value)
    elif x.node_type == nd_Ident:   return fetch_var(x.value)
    elif x.node_type == nd_String:  return x.value

    elif x.node_type == nd_Assign:
                    globals[x.left.value] = interp(x.right)
                    return None
    elif x.node_type == nd_Add:     return interp(x.left) +   interp(x.right)
    elif x.node_type == nd_Sub:     return interp(x.left) -   interp(x.right)
    elif x.node_type == nd_Mul:     return interp(x.left) *   interp(x.right)
    # use C like division semantics
    # another way: abs(x) / abs(y) * cmp(x, 0) * cmp(y, 0)
    elif x.node_type == nd_Div:     return int(float(interp(x.left)) / interp(x.right))
    elif x.node_type == nd_Mod:     return int(float(interp(x.left)) % interp(x.right))
    elif x.node_type == nd_Lss:     return interp(x.left) <   interp(x.right)
    elif x.node_type == nd_Gtr:     return interp(x.left) >   interp(x.right)
    elif x.node_type == nd_Leq:     return interp(x.left) <=  interp(x.right)
    elif x.node_type == nd_Geq:     return interp(x.left) >=  interp(x.right)
    elif x.node_type == nd_Eql:     return interp(x.left) ==  interp(x.right)
    elif x.node_type == nd_Neq:     return interp(x.left) !=  interp(x.right)
    elif x.node_type == nd_And:     return interp(x.left) and interp(x.right)
    elif x.node_type == nd_Or:      return interp(x.left) or  interp(x.right)
    elif x.node_type == nd_Negate:  return -interp(x.left)
    elif x.node_type == nd_Not:     return not interp(x.left)

    elif x.node_type ==  nd_If:
                    if (interp(x.left)):
                        interp(x.right.left)
                    else:
                        interp(x.right.right)
                    return None

    elif x.node_type == nd_While:
                    while (interp(x.left)):
                        interp(x.right)
                    return None

    elif x.node_type == nd_Prtc:
                    print("%c" % (interp(x.left)), end='')
                    return None

    elif x.node_type == nd_Prti:
                    print("%d" % (interp(x.left)), end='')
                    return None

    elif x.node_type == nd_Prts:
                    print(interp(x.left), end='')
                    return None

    elif x.node_type == nd_Sequence:
                    interp(x.left)
                    interp(x.right)
                    return None
    else:
        error("error in code generator - found %d, expecting operator" % (x.node_type))

def str_trans(srce):
    dest = ""
    i = 0
    srce = srce[1:-1]
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

def load_ast():
    line = input_file.readline()
    line_list = shlex.split(line, False, False)

    text = line_list[0]

    value = None
    if len(line_list) > 1:
        value = line_list[1]
        if value.isdigit():
            value = int(value)

    if text == ";":
        return None
    node_type = all_syms[text]
    if value != None:
        if node_type == nd_String:
            value = str_trans(value)

        return make_leaf(node_type, value)
    left = load_ast()
    right = load_ast()
    return make_node(node_type, left, right)

#*** main driver
input_file = sys.stdin
if len(sys.argv) > 1:
    try:
        input_file = open(sys.argv[1], "r", 4096)
    except IOError as e:
        error(0, 0, "Can't open %s" % sys.argv[1])

n = load_ast()
interp(n)
