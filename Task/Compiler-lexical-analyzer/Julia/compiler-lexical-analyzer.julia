struct Tokenized
    startline::Int
    startcol::Int
    name::String
    value::Union{Nothing, Int, String}
end

const optokens = Dict("*" => "Op_multiply", "/" => "Op_divide", "%" => "Op_mod", "+" => "Op_add",
                      "-" => "Op_subtract", "!" => "Op_not", "<" => "Op_less", "<=" => "Op_lessequal",
                      ">" => "Op_greater", ">=" => "Op_greaterequal", "==" => "Op_equal", "!=" => "Op_notequal",
                      "!" => "Op_not", "=" => "Op_assign", "&&" => "Op_and", "||" => "Op_or")

const keywordtokens = Dict("if" => "Keyword_if", "else" => "Keyword_else", "while" => "Keyword_while",
                           "print" => "Keyword_print", "putc" => "Keyword_putc")

const symboltokens = Dict("(" => "LeftParen", ")" => "RightParen", "{" => "LeftBrace",
                          "}" => "RightBrace", ";" => "Semicolon", "," => "Comma")

const errors = ["Empty character constant.", "Unknown escape sequence.", "Multi-character constant.",
                "End-of-file in comment. Closing comment characters not found.",
                "End-of-file while scanning string literal. Closing string character not found.",
                "End-of-line while scanning string literal. Closing string character not found before end-of-line.",
                "Unrecognized character.", "Invalid number. Starts like a number, but ends in non-numeric characters."]

asws(s) = (nnl = length(findall(x->x=='\n', s)); " " ^ (length(s) - nnl) * "\n" ^ nnl)
comment2ws(t) = (while occursin("/*", t) t = replace(t, r"\/\* .+? (?: \*\/)"xs => asws; count = 1) end; t)
hasinvalidescapes(t) = ((m = match(r"\\.", t)) != nothing && m.match != "\\\\" && m.match != "\\n")
hasemptycharconstant(t) = (match(r"\'\'", t) != nothing)
hasmulticharconstant(t) = ((m = match(r"\'[^\'][^\']+\'", t)) != nothing && m.match != "\'\\\\\'" && m.match != "\'\\n\'")
hasunbalancedquotes(t) = isodd(length(findall(x -> x == '\"', t)))
hasunrecognizedchar(t) = match(r"[^\w\s\d\*\/\%\+\-\<\>\=\!\&\|\(\)\{\}\;\,\"\'\\]", t) != nothing

function throwiferror(line, n)
    if hasemptycharconstant(line)
        throw("Tokenizer error line $n: " * errors[1])
    end
    if hasinvalidescapes(line)
        throw("Tokenizer error line $n: " * errors[2])
    end
    if hasmulticharconstant(line)
    println("error at ", match(r"\'[^\'][^\']+\'", line).match)
        throw("Tokenizer error line $n: " * errors[3])
    end
    if occursin("/*", line)
        throw("Tokenizer error line $n: " * errors[4])
    end
    if hasunrecognizedchar(line)
        throw("Tokenizer error line $n: " * errors[7])
    end
end

function tokenize(txt)
    tokens = Vector{Tokenized}()
    txt = comment2ws(txt)
    lines = split(txt, "\n")
    if hasunbalancedquotes(txt)
        throw("Tokenizer error: $(errors[5])")
    end
    for (startline, line) in enumerate(lines)
        if strip(line) == ""
            continue
        end
        throwiferror(line, startline)
        lastc = Char(0)
        withintoken = 0
        for (startcol, c) in enumerate(line)
            if withintoken > 0
                withintoken -= 1
                continue
            elseif isspace(c[1])
                continue
            elseif (c == '=') && (startcol > 1) && ((c2 = line[startcol - 1]) in ['<', '>', '=', '!'])
                    tokens[end] = Tokenized(startline, startcol - 1, optokens[c2 * c], nothing)
            elseif (c == '&') || (c == '|')
                if length(line) > startcol && line[startcol + 1] == c
                    push!(tokens, Tokenized(startline, startcol, optokens[c * c], nothing))
                    withintoken = 1
                else
                    throw("Tokenizer error line $startline: $(errors[7])")
                end
            elseif haskey(optokens, string(c))
                push!(tokens, Tokenized(startline, startcol, optokens[string(c)], nothing))
            elseif haskey(symboltokens, string(c))
                push!(tokens, Tokenized(startline, startcol, symboltokens[string(c)], nothing))
            elseif isdigit(c)
                integerstring = match(r"^\d+", line[startcol:end]).match
                pastnumposition = startcol + length(integerstring)
                if (pastnumposition <= length(line)) && isletter(line[pastnumposition])
                    throw("Tokenizer error line $startline: " * errors[8])
                end
                i = parse(Int, integerstring)
                push!(tokens, Tokenized(startline, startcol, "Integer", i))
                withintoken = length(integerstring) - 1
            elseif c == Char(39)  # single quote
                if (m = match(r"([^\\\'\n]|\\n|\\\\)\'", line[startcol+1:end])) != nothing
                    chs = m.captures[1]
                    i = (chs == "\\n") ? Int('\n') : (chs == "\\\\" ? Int('\\') : Int(chs[1]))
                    push!(tokens, Tokenized(startline, startcol, "Integer", i))
                    withintoken = length(chs) + 1
                else
                    println("line $startline: bad match with ", line[startcol+1:end])
                end
            elseif c == Char(34)  # double quote
                if (m = match(r"([^\"\n]+)\"", line[startcol+1:end])) == nothing
                    throw("Tokenizer error line $startline: $(errors[6])")
                end
                litstring = m.captures[1]
                push!(tokens, Tokenized(startline, startcol, "String", "\"$litstring\""))
                withintoken = length(litstring) + 1
            elseif (cols = findfirst(r"[a-zA-Z]+", line[startcol:end])) != nothing
                litstring = line[cols .+ startcol .- 1]
                if haskey(keywordtokens, string(litstring))
                    push!(tokens, Tokenized(startline, startcol, keywordtokens[litstring], nothing))
                else
                    litstring = match(r"[_a-zA-Z0-9]+", line[startcol:end]).match
                    push!(tokens, Tokenized(startline, startcol, "Identifier", string(litstring)))
                end
                withintoken = length(litstring) - 1
            end
            lastc = c
        end
    end
    push!(tokens, Tokenized(length(lines), length(lines[end]) + 1, "End_of_input", nothing))
    tokens
end

const test3txt = raw"""
/*
  All lexical tokens - not syntactically correct, but that will
  have to wait until syntax analysis
 */
/* Print   */  print    /* Sub     */  -
/* Putc    */  putc     /* Lss     */  <
/* If      */  if       /* Gtr     */  >
/* Else    */  else     /* Leq     */  <=
/* While   */  while    /* Geq     */  >=
/* Lbrace  */  {        /* Eq      */  ==
/* Rbrace  */  }        /* Neq     */  !=
/* Lparen  */  (        /* And     */  &&
/* Rparen  */  )        /* Or      */  ||
/* Uminus  */  -        /* Semi    */  ;
/* Not     */  !        /* Comma   */  ,
/* Mul     */  *        /* Assign  */  =
/* Div     */  /        /* Integer */  42
/* Mod     */  %        /* String  */  "String literal"
/* Add     */  +        /* Ident   */  variable_name
/* character literal */  '\n'
/* character literal */  '\\'
/* character literal */  ' '
"""

println("Line Col        Name        Value")
for tok in tokenize(test3txt)
    println(lpad(tok.startline, 3), lpad(tok.startcol, 5), lpad(tok.name, 18), "  ", tok.value != nothing ? tok.value : "")
end
