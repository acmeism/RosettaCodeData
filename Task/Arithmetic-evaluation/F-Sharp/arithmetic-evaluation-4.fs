open AbstractSyntaxTree
open Lexer
open Parser

let parse txt =
  txt
  |> Lexing.LexBuffer<_>.FromString
  |> Parser.Expr Lexer.token

let rec eval = function
  | Int i        -> i
  | Plus (a,b)   -> eval a + eval b
  | Minus (a,b)  -> eval a - eval b
  | Times (a,b)  -> eval a * eval b
  | Divide (a,b) -> eval a / eval b

do
  "((11+15)*15)*2-(3)*4*1"
  |> parse
  |> eval
  |> printfn "%d"
