include std/io.e
include std/map.e
include std/types.e
include std/convert.e

constant true = 1, false = 0, EOF = -1

enum tk_EOI, tk_Mul, tk_Div, tk_Mod, tk_Add, tk_Sub, tk_Negate, tk_Not, tk_Lss, tk_Leq,
    tk_Gtr, tk_Geq, tk_Eq, tk_Neq, tk_Assign, tk_And, tk_Or, tk_If, tk_Else, tk_While,
    tk_Print, tk_Putc, tk_Lparen, tk_Rparen, tk_Lbrace, tk_Rbrace, tk_Semi, tk_Comma,
    tk_Ident, tk_Integer, tk_String

constant all_syms = {"End_of_input", "Op_multiply", "Op_divide", "Op_mod", "Op_add",
    "Op_subtract", "Op_negate", "Op_not", "Op_less", "Op_lessequal", "Op_greater",
    "Op_greaterequal", "Op_equal", "Op_notequal", "Op_assign", "Op_and", "Op_or",
    "Keyword_if", "Keyword_else", "Keyword_while", "Keyword_print", "Keyword_putc",
    "LeftParen", "RightParen", "LeftBrace", "RightBrace", "Semicolon", "Comma",
    "Identifier", "Integer", "String"}

integer input_file, the_ch = ' ', the_col = 0, the_line = 1
sequence symbols
map key_words = new()

procedure error(sequence format, sequence data)
    printf(STDOUT, format, data)
    abort(1)
end procedure

-- get the next character from the input
function next_ch()
    the_ch = getc(input_file)
    the_col += 1
    if the_ch = '\n' then
        the_line += 1
        the_col = 0
    end if
    return the_ch
end function

-- 'x' - character constants
function char_lit(integer err_line, integer err_col)
    integer n = next_ch()              -- skip opening quote
    if the_ch = '\'' then
        error("%d %d empty character constant", {err_line, err_col})
    elsif the_ch = '\\' then
        next_ch()
        if the_ch = 'n' then
            n = 10
        elsif the_ch = '\\' then
            n = '\\'
        else
            error("%d %d unknown escape sequence \\%c", {err_line, err_col, the_ch})
        end if
    end if
    if next_ch() != '\'' then
        error("%d %d multi-character constant", {err_line, err_col})
    end if
    next_ch()
    return {tk_Integer, err_line, err_col, n}
end function

-- process divide or comments
function div_or_cmt(integer err_line, integer err_col)
    if next_ch() != '*' then
        return {tk_Div, err_line, err_col}
    end if

    -- comment found
    next_ch()
    while true do
        if the_ch = '*' then
            if next_ch() = '/' then
                next_ch()
                return get_tok()
            end if
        elsif the_ch = EOF then
            error("%d %d EOF in comment", {err_line, err_col})
        else
            next_ch()
        end if
    end while
end function

-- "string"
function string_lit(integer start, integer err_line, integer err_col)
    string text = ""

    while next_ch() != start do
        if the_ch = EOF then
            error("%d %d EOF while scanning string literal", {err_line, err_col})
        end if
        if the_ch = '\n' then
            error("%d %d EOL while scanning string literal", {err_line, err_col})
        end if
        text &= the_ch
    end while

    next_ch()
    return {tk_String, err_line, err_col, text}
end function

-- handle identifiers and integers
function ident_or_int(integer err_line, integer err_col)
    integer n, is_number = true
    string text = ""

    while t_alnum(the_ch) or the_ch = '_' do
        text &= the_ch
        if not t_digit(the_ch) then
            is_number = false
        end if
        next_ch()
    end while

    if length(text) = 0 then
        error("%d %d ident_or_int: unrecognized character: (%d) '%s'", {err_line, err_col, the_ch, the_ch})
    end if

    if t_digit(text[1]) then
        if not is_number then
            error("%d %d invalid number: %s", {err_line, err_col, text})
        end if
        n = to_integer(text)
        return {tk_Integer, err_line, err_col, n}
    end if

    if has(key_words, text) then
        return {get(key_words, text), err_line, err_col}
    end if

    return {tk_Ident, err_line, err_col, text}
end function

-- look ahead for '>=', etc.
function follow(integer expect, integer ifyes, integer ifno, integer err_line, integer err_col)
    if next_ch() = expect then
        next_ch()
        return {ifyes, err_line, err_col}
    end if

    if ifno = tk_EOI then
        error("%d %d follow: unrecognized character: (%d)", {err_line, err_col, the_ch})
    end if

    return {ifno, err_line, err_col}
end function

-- return the next token type
function get_tok()
    while t_space(the_ch) do
        next_ch()
    end while

    integer err_line = the_line
    integer err_col  = the_col

    switch the_ch do
        case EOF  then return {tk_EOI, err_line, err_col}
        case '/'  then return div_or_cmt(err_line, err_col)
        case '\'' then return char_lit(err_line, err_col)

        case '<'  then return follow('=', tk_Leq, tk_Lss,    err_line, err_col)
        case '>'  then return follow('=', tk_Geq, tk_Gtr,    err_line, err_col)
        case '='  then return follow('=', tk_Eq,  tk_Assign, err_line, err_col)
        case '!'  then return follow('=', tk_Neq, tk_Not,    err_line, err_col)
        case '&'  then return follow('&', tk_And, tk_EOI,    err_line, err_col)
        case '|'  then return follow('|', tk_Or,  tk_EOI,    err_line, err_col)

        case '"'  then return string_lit(the_ch, err_line, err_col)
        case else
            integer sym = symbols[the_ch]
            if sym  != tk_EOI then
                next_ch()
                return {sym, err_line, err_col}
            end if
            return ident_or_int(err_line, err_col)
    end switch
end function

procedure init()
    put(key_words, "else",    tk_Else)
    put(key_words, "if",      tk_If)
    put(key_words, "print",   tk_Print)
    put(key_words, "putc",    tk_Putc)
    put(key_words, "while",   tk_While)

    symbols = repeat(tk_EOI, 256)
    symbols['{'] = tk_Lbrace
    symbols['}'] = tk_Rbrace
    symbols['('] = tk_Lparen
    symbols[')'] = tk_Rparen
    symbols['+'] = tk_Add
    symbols['-'] = tk_Sub
    symbols['*'] = tk_Mul
    symbols['%'] = tk_Mod
    symbols[';'] = tk_Semi
    symbols[','] = tk_Comma
end procedure

procedure main(sequence cl)
    sequence file_name

    input_file = STDIN
    if length(cl) > 2 then
        file_name = cl[3]
        input_file = open(file_name, "r")
        if input_file = -1 then
            error("Could not open %s", {file_name})
        end if
    end if
    init()
    sequence t
    loop do
        t = get_tok()
        printf(STDOUT, "%5d  %5d %-8s", {t[2], t[3], all_syms[t[1]]})
        switch t[1] do
            case tk_Integer then printf(STDOUT, "  %5d\n",   {t[4]})
            case tk_Ident   then printf(STDOUT, " %s\n",     {t[4]})
            case tk_String  then printf(STDOUT, " \"%s\"\n", {t[4]})
            case else            printf(STDOUT, "\n")
        end switch
        until t[1] = tk_EOI
    end loop
end procedure

main(command_line())
