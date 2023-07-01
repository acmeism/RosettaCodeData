from __future__ import print_function
import sys, shlex, operator

tk_EOI, tk_Mul, tk_Div, tk_Mod, tk_Add, tk_Sub, tk_Negate, tk_Not, tk_Lss, tk_Leq, tk_Gtr, \
tk_Geq, tk_Eql, tk_Neq, tk_Assign, tk_And, tk_Or, tk_If, tk_Else, tk_While, tk_Print,      \
tk_Putc, tk_Lparen, tk_Rparen, tk_Lbrace, tk_Rbrace, tk_Semi, tk_Comma, tk_Ident,          \
tk_Integer, tk_String = range(31)

nd_Ident, nd_String, nd_Integer, nd_Sequence, nd_If, nd_Prtc, nd_Prts, nd_Prti, nd_While, \
nd_Assign, nd_Negate, nd_Not, nd_Mul, nd_Div, nd_Mod, nd_Add, nd_Sub, nd_Lss, nd_Leq,     \
nd_Gtr, nd_Geq, nd_Eql, nd_Neq, nd_And, nd_Or = range(25)

# must have same order as above
Tokens = [
    ["EOI"             , False, False, False, -1, -1        ],
    ["*"               , False, True,  False, 13, nd_Mul    ],
    ["/"               , False, True,  False, 13, nd_Div    ],
    ["%"               , False, True,  False, 13, nd_Mod    ],
    ["+"               , False, True,  False, 12, nd_Add    ],
    ["-"               , False, True,  False, 12, nd_Sub    ],
    ["-"               , False, False, True,  14, nd_Negate ],
    ["!"               , False, False, True,  14, nd_Not    ],
    ["<"               , False, True,  False, 10, nd_Lss    ],
    ["<="              , False, True,  False, 10, nd_Leq    ],
    [">"               , False, True,  False, 10, nd_Gtr    ],
    [">="              , False, True,  False, 10, nd_Geq    ],
    ["=="              , False, True,  False,  9, nd_Eql    ],
    ["!="              , False, True,  False,  9, nd_Neq    ],
    ["="               , False, False, False, -1, nd_Assign ],
    ["&&"              , False, True,  False,  5, nd_And    ],
    ["||"              , False, True,  False,  4, nd_Or     ],
    ["if"              , False, False, False, -1, nd_If     ],
    ["else"            , False, False, False, -1, -1        ],
    ["while"           , False, False, False, -1, nd_While  ],
    ["print"           , False, False, False, -1, -1        ],
    ["putc"            , False, False, False, -1, -1        ],
    ["("               , False, False, False, -1, -1        ],
    [")"               , False, False, False, -1, -1        ],
    ["{"               , False, False, False, -1, -1        ],
    ["}"               , False, False, False, -1, -1        ],
    [";"               , False, False, False, -1, -1        ],
    [","               , False, False, False, -1, -1        ],
    ["Ident"           , False, False, False, -1, nd_Ident  ],
    ["Integer literal" , False, False, False, -1, nd_Integer],
    ["String literal"  , False, False, False, -1, nd_String ]
    ]

all_syms = {"End_of_input"   : tk_EOI,     "Op_multiply"    : tk_Mul,
            "Op_divide"      : tk_Div,     "Op_mod"         : tk_Mod,
            "Op_add"         : tk_Add,     "Op_subtract"    : tk_Sub,
            "Op_negate"      : tk_Negate,  "Op_not"         : tk_Not,
            "Op_less"        : tk_Lss,     "Op_lessequal"   : tk_Leq,
            "Op_greater"     : tk_Gtr,     "Op_greaterequal": tk_Geq,
            "Op_equal"       : tk_Eql,     "Op_notequal"    : tk_Neq,
            "Op_assign"      : tk_Assign,  "Op_and"         : tk_And,
            "Op_or"          : tk_Or,      "Keyword_if"     : tk_If,
            "Keyword_else"   : tk_Else,    "Keyword_while"  : tk_While,
            "Keyword_print"  : tk_Print,   "Keyword_putc"   : tk_Putc,
            "LeftParen"      : tk_Lparen,  "RightParen"     : tk_Rparen,
            "LeftBrace"      : tk_Lbrace,  "RightBrace"     : tk_Rbrace,
            "Semicolon"      : tk_Semi,    "Comma"          : tk_Comma,
            "Identifier"     : tk_Ident,   "Integer"        : tk_Integer,
            "String"         : tk_String}

Display_nodes = ["Identifier", "String", "Integer", "Sequence", "If", "Prtc", "Prts",
    "Prti", "While", "Assign", "Negate", "Not", "Multiply", "Divide", "Mod", "Add",
    "Subtract", "Less", "LessEqual", "Greater", "GreaterEqual", "Equal", "NotEqual",
    "And", "Or"]

TK_NAME         = 0
TK_RIGHT_ASSOC  = 1
TK_IS_BINARY    = 2
TK_IS_UNARY     = 3
TK_PRECEDENCE   = 4
TK_NODE         = 5

input_file = None
err_line   = None
err_col    = None
tok        = None
tok_text   = None

#*** show error and exit
def error(msg):
    print("(%d, %d) %s" % (int(err_line), int(err_col), msg))
    exit(1)

#***
def gettok():
    global err_line, err_col, tok, tok_text, tok_other
    line = input_file.readline()
    if len(line) == 0:
        error("empty line")

    line_list = shlex.split(line, False, False)
    # line col Ident var_name
    # 0    1   2     3

    err_line = line_list[0]
    err_col  = line_list[1]
    tok_text = line_list[2]

    tok = all_syms.get(tok_text)
    if tok == None:
        error("Unknown token %s" % (tok_text))

    tok_other = None
    if tok in [tk_Integer, tk_Ident, tk_String]:
        tok_other = line_list[3]

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
def expect(msg, s):
    if tok == s:
        gettok()
        return
    error("%s: Expecting '%s', found '%s'" % (msg, Tokens[s][TK_NAME], Tokens[tok][TK_NAME]))

#***
def expr(p):
    x = None

    if tok == tk_Lparen:
        x = paren_expr()
    elif tok in [tk_Sub, tk_Add]:
        op = (tk_Negate if tok == tk_Sub else tk_Add)
        gettok()
        node = expr(Tokens[tk_Negate][TK_PRECEDENCE])
        x = (make_node(nd_Negate, node) if op == tk_Negate else node)
    elif tok == tk_Not:
        gettok()
        x = make_node(nd_Not, expr(Tokens[tk_Not][TK_PRECEDENCE]))
    elif tok == tk_Ident:
        x = make_leaf(nd_Ident, tok_other)
        gettok()
    elif tok == tk_Integer:
        x = make_leaf(nd_Integer, tok_other)
        gettok()
    else:
        error("Expecting a primary, found: %s" % (Tokens[tok][TK_NAME]))

    while Tokens[tok][TK_IS_BINARY] and Tokens[tok][TK_PRECEDENCE] >= p:
        op = tok
        gettok()
        q = Tokens[op][TK_PRECEDENCE]
        if not Tokens[op][TK_RIGHT_ASSOC]:
            q += 1

        node = expr(q)
        x = make_node(Tokens[op][TK_NODE], x, node)

    return x

#***
def paren_expr():
    expect("paren_expr", tk_Lparen)
    node = expr(0)
    expect("paren_expr", tk_Rparen)
    return node

#***
def stmt():
    t = None

    if tok == tk_If:
        gettok()
        e = paren_expr()
        s = stmt()
        s2 = None
        if tok == tk_Else:
            gettok()
            s2 = stmt()
        t = make_node(nd_If, e, make_node(nd_If, s, s2))
    elif tok == tk_Putc:
        gettok()
        e = paren_expr()
        t = make_node(nd_Prtc, e)
        expect("Putc", tk_Semi)
    elif tok == tk_Print:
        gettok()
        expect("Print", tk_Lparen)
        while True:
            if tok == tk_String:
                e = make_node(nd_Prts, make_leaf(nd_String, tok_other))
                gettok()
            else:
                e = make_node(nd_Prti, expr(0))

            t = make_node(nd_Sequence, t, e)
            if tok != tk_Comma:
                break
            gettok()
        expect("Print", tk_Rparen)
        expect("Print", tk_Semi)
    elif tok == tk_Semi:
        gettok()
    elif tok == tk_Ident:
        v = make_leaf(nd_Ident, tok_other)
        gettok()
        expect("assign", tk_Assign)
        e = expr(0)
        t = make_node(nd_Assign, v, e)
        expect("assign", tk_Semi)
    elif tok == tk_While:
        gettok()
        e = paren_expr()
        s = stmt()
        t = make_node(nd_While, e, s)
    elif tok == tk_Lbrace:
        gettok()
        while tok != tk_Rbrace and tok != tk_EOI:
            t = make_node(nd_Sequence, t, stmt())
        expect("Lbrace", tk_Rbrace)
    elif tok == tk_EOI:
        pass
    else:
        error("Expecting start of statement, found: %s" % (Tokens[tok][TK_NAME]))

    return t

#***
def parse():
    t = None
    gettok()
    while True:
        t = make_node(nd_Sequence, t, stmt())
        if tok == tk_EOI or t == None:
            break
    return t

def prt_ast(t):
    if t == None:
        print(";")
    else:
        print("%-14s" % (Display_nodes[t.node_type]), end='')
        if t.node_type in [nd_Ident, nd_Integer]:
            print("%s" % (t.value))
        elif t.node_type == nd_String:
            print("%s" %(t.value))
        else:
            print("")
            prt_ast(t.left)
            prt_ast(t.right)

#*** main driver
input_file = sys.stdin
if len(sys.argv) > 1:
    try:
        input_file = open(sys.argv[1], "r", 4096)
    except IOError as e:
        error(0, 0, "Can't open %s" % sys.argv[1])
t = parse()
prt_ast(t)
