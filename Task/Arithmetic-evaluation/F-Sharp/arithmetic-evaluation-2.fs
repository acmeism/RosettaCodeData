{
module Lexer

open Parser  // we need the terminal tokens from the Parser

let lexeme = Lexing.LexBuffer<_>.LexemeString
}

let intNum     = '-'? ['0'-'9']+
let whitespace = ' ' | '\t'
let newline    = '\n' | '\r' '\n'

rule token = parse
    | intNum     { INT (lexeme lexbuf |> int) }
    | '+'        { PLUS }
    | '-'        { MINUS }
    | '*'        { TIMES }
    | '/'        { DIVIDE }
    | '('        { LPAREN }
    | ')'        { RPAREN }
    | whitespace { token lexbuf }
    | newline    { lexbuf.EndPos <- lexbuf.EndPos.NextLine; token lexbuf }
    | eof        { EOF }
    | _          { failwithf "unrecognized input: '%s'" <| lexeme lexbuf }
