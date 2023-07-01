struct ASTnode
    nodetype::Int
    left::Union{Nothing, ASTnode}
    right::Union{Nothing, ASTnode}
    value::Union{Nothing, Int, String}
end

function syntaxanalyzer(inputfile)
    tkEOI, tkMul, tkDiv, tkMod, tkAdd, tkSub, tkNegate, tkNot, tkLss, tkLeq, tkGtr, tkGeq,
    tkEql, tkNeq, tkAssign, tkAnd, tkOr, tkIf, tkElse, tkWhile, tkPrint, tkPutc, tkLparen, tkRparen,
    tkLbrace, tkRbrace, tkSemi, tkComma, tkIdent, tkInteger, tkString = collect(1:31)

    ndIdent, ndString, ndInteger, ndSequence, ndIf, ndPrtc, ndPrts, ndPrti, ndWhile,
    ndAssign, ndNegate, ndNot, ndMul, ndDiv, ndMod, ndAdd, ndSub, ndLss, ndLeq,
    ndGtr, ndGeq, ndEql, ndNeq, ndAnd, ndOr = collect(1:25)

    TK_NAME, TK_RIGHT_ASSOC, TK_IS_BINARY, TK_IS_UNARY, TK_PRECEDENCE, TK_NODE = collect(1:6) # label Token columns
    Tokens = [
    ["EOI"             , false, false, false, -1, -1       ],
    ["*"               , false, true,  false, 13, ndMul    ],
    ["/"               , false, true,  false, 13, ndDiv    ],
    ["%"               , false, true,  false, 13, ndMod    ],
    ["+"               , false, true,  false, 12, ndAdd    ],
    ["-"               , false, true,  false, 12, ndSub    ],
    ["-"               , false, false, true,  14, ndNegate ],
    ["!"               , false, false, true,  14, ndNot    ],
    ["<"               , false, true,  false, 10, ndLss    ],
    ["<="              , false, true,  false, 10, ndLeq    ],
    [">"               , false, true,  false, 10, ndGtr    ],
    [">="              , false, true,  false, 10, ndGeq    ],
    ["=="              , false, true,  false,  9, ndEql    ],
    ["!="              , false, true,  false,  9, ndNeq    ],
    ["="               , false, false, false, -1, ndAssign ],
    ["&&"              , false, true,  false,  5, ndAnd    ],
    ["||"              , false, true,  false,  4, ndOr     ],
    ["if"              , false, false, false, -1, ndIf     ],
    ["else"            , false, false, false, -1, -1       ],
    ["while"           , false, false, false, -1, ndWhile  ],
    ["print"           , false, false, false, -1, -1       ],
    ["putc"            , false, false, false, -1, -1       ],
    ["("               , false, false, false, -1, -1       ],
    [")"               , false, false, false, -1, -1       ],
    ["{"               , false, false, false, -1, -1       ],
    ["}"               , false, false, false, -1, -1       ],
    [";"               , false, false, false, -1, -1       ],
    [","               , false, false, false, -1, -1       ],
    ["Ident"           , false, false, false, -1, ndIdent  ],
    ["Integer literal" , false, false, false, -1, ndInteger],
    ["String literal"  , false, false, false, -1, ndString ]]

    allsyms = Dict(
        "End_of_input" => tkEOI, "Op_multiply" => tkMul, "Op_divide" => tkDiv,
        "Op_mod" => tkMod, "Op_add" => tkAdd, "Op_subtract" => tkSub,
        "Op_negate" => tkNegate, "Op_not" => tkNot, "Op_less" => tkLss,
        "Op_lessequal" => tkLeq, "Op_greater" => tkGtr, "Op_greaterequal" => tkGeq,
        "Op_equal" => tkEql, "Op_notequal" => tkNeq, "Op_assign" => tkAssign,
        "Op_and" => tkAnd, "Op_or" => tkOr, "Keyword_if" => tkIf, "Keyword_else" => tkElse,
        "Keyword_while" => tkWhile, "Keyword_print" => tkPrint, "Keyword_putc" => tkPutc,
        "LeftParen" => tkLparen, "RightParen" => tkRparen, "LeftBrace" => tkLbrace,
        "RightBrace" => tkRbrace, "Semicolon" => tkSemi, "Comma" => tkComma,
        "Identifier" => tkIdent, "Integer" => tkInteger, "String" => tkString)

    displaynodes = ["Identifier", "String", "Integer", "Sequence", "If", "Prtc", "Prts", "Prti", "While",
                     "Assign", "Negate", "Not", "Multiply", "Divide", "Mod", "Add", "Subtract", "Less",
                     "LessEqual", "Greater", "GreaterEqual", "Equal", "NotEqual", "And", "Or"]

    errline, errcol, tok, toktext = fill("", 4)
    error(msg) = throw("Error in syntax: $msg.")
    nilnode = ASTnode(0, nothing, nothing, nothing)
    tokother = ""

    function gettok()
        s = readline(inputfile)
        if length(s) == 0
            error("empty line")
        end
        linelist = split(strip(s), r"\s+", limit = 4)
        # line col Ident varname
        # 0    1   2     3
        errline, errcol, toktext = linelist[1:3]
        if !haskey(allsyms, toktext)
            error("Unknown token $toktext")
        end
        tok = allsyms[toktext]
        tokother = (tok in [tkInteger, tkIdent, tkString]) ? linelist[4] : ""
     end

    makenode(oper, left, right = nilnode) = ASTnode(oper, left, right, nothing)
    makeleaf(oper, n::Int) = ASTnode(oper, nothing, nothing, n)
    makeleaf(oper, n) = ASTnode(oper, nothing, nothing, string(n))
    expect(msg, s) = if tok != s error("msg: Expecting $(Tokens[s][TK_NAME]), found $(Tokens[tok][TK_NAME])") else gettok() end

    function expr(p)
        x = nilnode
        if tok == tkLparen
            x = parenexpr()
        elseif tok in [tkSub, tkAdd]
            op = tok == tkSub ? tkNegate : tkAdd
            gettok()
            node = expr(Tokens[tkNegate][TK_PRECEDENCE])
            x = (op == tkNegate) ? makenode(ndNegate, node) : node
        elseif tok == tkNot
            gettok()
            x = makenode(ndNot, expr(Tokens[tkNot][TK_PRECEDENCE]))
        elseif tok == tkIdent
            x = makeleaf(ndIdent, tokother)
            gettok()
        elseif tok == tkInteger
            x = makeleaf(ndInteger, tokother)
            gettok()
        else
            error("Expecting a primary, found: $(Tokens[tok][TK_NAME])")
        end
        while Tokens[tok][TK_IS_BINARY] && (Tokens[tok][TK_PRECEDENCE] >= p)
            op = tok
            gettok()
            q = Tokens[op][TK_PRECEDENCE]
            if !Tokens[op][TK_RIGHT_ASSOC]
                q += 1
            end
            node = expr(q)
            x = makenode(Tokens[op][TK_NODE], x, node)
        end
        x
    end

    parenexpr() = (expect("paren_expr", tkLparen); node = expr(0); expect("paren_expr", tkRparen); node)

    function stmt()
        t = nilnode
        if tok == tkIf
            gettok()
            e = parenexpr()
            s = stmt()
            s2 = nilnode
            if tok == tkElse
                gettok()
                s2 = stmt()
            end
            t = makenode(ndIf, e, makenode(ndIf, s, s2))
        elseif tok == tkPutc
            gettok()
            e = parenexpr()
            t = makenode(ndPrtc, e)
            expect("Putc", tkSemi)
        elseif tok == tkPrint
            gettok()
            expect("Print", tkLparen)
            while true
                if tok == tkString
                    e = makenode(ndPrts, makeleaf(ndString, tokother))
                    gettok()
                else
                    e = makenode(ndPrti, expr(0))
                end
                t = makenode(ndSequence, t, e)
                if tok != tkComma
                    break
                end
                gettok()
            end
            expect("Print", tkRparen)
            expect("Print", tkSemi)
        elseif tok == tkSemi
            gettok()
        elseif tok == tkIdent
            v = makeleaf(ndIdent, tokother)
            gettok()
            expect("assign", tkAssign)
            e = expr(0)
            t = makenode(ndAssign, v, e)
            expect("assign", tkSemi)
        elseif tok == tkWhile
            gettok()
            e = parenexpr()
            s = stmt()
            t = makenode(ndWhile, e, s)
        elseif tok == tkLbrace
            gettok()
            while (tok != tkRbrace) && (tok != tkEOI)
                t = makenode(ndSequence, t, stmt())
            end
            expect("Lbrace", tkRbrace)
        elseif tok != tkEOI
            error("Expecting start of statement, found: $(Tokens[tok][TK_NAME])")
        end
        return t
    end

    function parse()
        t = nilnode
        gettok()
        while true
            t = makenode(ndSequence, t, stmt())
            if (tok == tkEOI) || (t == nilnode)
                break
            end
        end
        t
    end

    function prtASTnode(t)
        if t == nothing
            return
        elseif t == nilnode
            println(";")
        elseif t.nodetype in [ndIdent, ndInteger, ndString]
            println(rpad(displaynodes[t.nodetype], 14), t.value)
        else
            println(rpad(displaynodes[t.nodetype], 14))
        end
        prtASTnode(t.left)
        prtASTnode(t.right)
    end

    # runs the function
    prtASTnode(parse())
end

testtxt = """
    1      1 Identifier      count
    1      7 Op_assign
    1      9 Integer             1
    1     10 Semicolon
    2      1 Keyword_while
    2      7 LeftParen
    2      8 Identifier      count
    2     14 Op_less
    2     16 Integer            10
    2     18 RightParen
    2     20 LeftBrace
    3      5 Keyword_print
    3     10 LeftParen
    3     11 String          \"count is: \"
    3     23 Comma
    3     25 Identifier      count
    3     30 Comma
    3     32 String          \"\\n\"
    3     36 RightParen
    3     37 Semicolon
    4      5 Identifier      count
    4     11 Op_assign
    4     13 Identifier      count
    4     19 Op_add
    4     21 Integer             1
    4     22 Semicolon
    5      1 RightBrace
    6      1 End_of_input           """

syntaxanalyzer(IOBuffer(testtxt))  # for isolated testing

# syntaxanalyzer(length(ARGS) > 1 ? ARGS[1] : stdin) # for use as in the Python code
