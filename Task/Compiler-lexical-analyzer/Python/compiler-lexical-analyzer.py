from __future__ import print_function
import sys

# following two must remain in the same order

tk_EOI, tk_Mul, tk_Div, tk_Mod, tk_Add, tk_Sub, tk_Negate, tk_Not, tk_Lss, tk_Leq, tk_Gtr, \
tk_Geq, tk_Eq, tk_Neq, tk_Assign, tk_And, tk_Or, tk_If, tk_Else, tk_While, tk_Print,       \
tk_Putc, tk_Lparen, tk_Rparen, tk_Lbrace, tk_Rbrace, tk_Semi, tk_Comma, tk_Ident,          \
tk_Integer, tk_String = range(31)

all_syms = ["End_of_input", "Op_multiply", "Op_divide", "Op_mod", "Op_add", "Op_subtract",
    "Op_negate", "Op_not", "Op_less", "Op_lessequal", "Op_greater", "Op_greaterequal",
    "Op_equal", "Op_notequal", "Op_assign", "Op_and", "Op_or", "Keyword_if",
    "Keyword_else", "Keyword_while", "Keyword_print", "Keyword_putc", "LeftParen",
    "RightParen", "LeftBrace", "RightBrace", "Semicolon", "Comma", "Identifier",
    "Integer", "String"]

# single character only symbols
symbols = { '{': tk_Lbrace, '}': tk_Rbrace, '(': tk_Lparen, ')': tk_Rparen, '+': tk_Add, '-': tk_Sub,
    '*': tk_Mul, '%': tk_Mod, ';': tk_Semi, ',': tk_Comma }

key_words = {'if': tk_If, 'else': tk_Else, 'print': tk_Print, 'putc': tk_Putc, 'while': tk_While}

the_ch = " "    # dummy first char - but it must be a space
the_col = 0
the_line = 1
input_file = None

#*** show error and exit
def error(line, col, msg):
    print(line, col, msg)
    exit(1)

#*** get the next character from the input
def next_ch():
    global the_ch, the_col, the_line

    the_ch = input_file.read(1)
    the_col += 1
    if the_ch == '\n':
        the_line += 1
        the_col = 0
    return the_ch

#*** 'x' - character constants
def char_lit(err_line, err_col):
    n = ord(next_ch())              # skip opening quote
    if the_ch == '\'':
        error(err_line, err_col, "empty character constant")
    elif the_ch == '\\':
        next_ch()
        if the_ch == 'n':
            n = 10
        elif the_ch == '\\':
            n = ord('\\')
        else:
            error(err_line, err_col, "unknown escape sequence \\%c" % (the_ch))
    if next_ch() != '\'':
        error(err_line, err_col, "multi-character constant")
    next_ch()
    return tk_Integer, err_line, err_col, n

#*** process divide or comments
def div_or_cmt(err_line, err_col):
    if next_ch() != '*':
        return tk_Div, err_line, err_col

    # comment found
    next_ch()
    while True:
        if the_ch == '*':
            if next_ch() == '/':
                next_ch()
                return gettok()
        elif len(the_ch) == 0:
            error(err_line, err_col, "EOF in comment")
        else:
            next_ch()

#*** "string"
def string_lit(start, err_line, err_col):
    global the_ch
    text = ""

    while next_ch() != start:
        if len(the_ch) == 0:
            error(err_line, err_col, "EOF while scanning string literal")
        if the_ch == '\n':
            error(err_line, err_col, "EOL while scanning string literal")
        if the_ch == '\\':
            next_ch()
            if the_ch != 'n':
                error(err_line, err_col, "escape sequence unknown \\%c" % the_ch)
            the_ch = '\n'
        text += the_ch

    next_ch()
    return tk_String, err_line, err_col, text

#*** handle identifiers and integers
def ident_or_int(err_line, err_col):
    is_number = True
    text = ""

    while the_ch.isalnum() or the_ch == '_':
        text += the_ch
        if not the_ch.isdigit():
            is_number = False
        next_ch()

    if len(text) == 0:
        error(err_line, err_col, "ident_or_int: unrecognized character: (%d) '%c'" % (ord(the_ch), the_ch))

    if text[0].isdigit():
        if not is_number:
            error(err_line, err_col, "invalid number: %s" % (text))
        n = int(text)
        return tk_Integer, err_line, err_col, n

    if text in key_words:
        return key_words[text], err_line, err_col

    return tk_Ident, err_line, err_col, text

#*** look ahead for '>=', etc.
def follow(expect, ifyes, ifno, err_line, err_col):
    if next_ch() == expect:
        next_ch()
        return ifyes, err_line, err_col

    if ifno == tk_EOI:
        error(err_line, err_col, "follow: unrecognized character: (%d) '%c'" % (ord(the_ch), the_ch))

    return ifno, err_line, err_col

#*** return the next token type
def gettok():
    while the_ch.isspace():
        next_ch()

    err_line = the_line
    err_col  = the_col

    if len(the_ch) == 0:    return tk_EOI, err_line, err_col
    elif the_ch == '/':     return div_or_cmt(err_line, err_col)
    elif the_ch == '\'':    return char_lit(err_line, err_col)
    elif the_ch == '<':     return follow('=', tk_Leq, tk_Lss,    err_line, err_col)
    elif the_ch == '>':     return follow('=', tk_Geq, tk_Gtr,    err_line, err_col)
    elif the_ch == '=':     return follow('=', tk_Eq,  tk_Assign, err_line, err_col)
    elif the_ch == '!':     return follow('=', tk_Neq, tk_Not,    err_line, err_col)
    elif the_ch == '&':     return follow('&', tk_And, tk_EOI,    err_line, err_col)
    elif the_ch == '|':     return follow('|', tk_Or,  tk_EOI,    err_line, err_col)
    elif the_ch == '"':     return string_lit(the_ch, err_line, err_col)
    elif the_ch in symbols:
        sym = symbols[the_ch]
        next_ch()
        return sym, err_line, err_col
    else: return ident_or_int(err_line, err_col)

#*** main driver
input_file = sys.stdin
if len(sys.argv) > 1:
    try:
        input_file = open(sys.argv[1], "r", 4096)
    except IOError as e:
        error(0, 0, "Can't open %s" % sys.argv[1])

while True:
    t = gettok()
    tok  = t[0]
    line = t[1]
    col  = t[2]

    print("%5d  %5d   %-14s" % (line, col, all_syms[tok]), end='')

    if tok == tk_Integer:  print("   %5d" % (t[3]))
    elif tok == tk_Ident:  print("  %s" %   (t[3]))
    elif tok == tk_String: print('  "%s"' % (t[3]))
    else:                  print("")

    if tok == tk_EOI:
        break
