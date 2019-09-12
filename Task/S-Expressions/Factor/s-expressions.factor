USING: formatting kernel math.parser multiline peg peg.ebnf
regexp sequences prettyprint words ;
IN: rosetta-code.s-expressions

STRING: input
((data "quoted data" 123 4.5)
 (data (!@# (4.5) "(more" "data)")))
;

EBNF: sexp>seq [=[
  ws     = [\n\t\r ]* => [[ drop ignore ]]
  digits = [0-9]+
  number = digits => [[ string>number ]]
  float  = digits:a "." digits:b => [[ a b "." glue string>number ]]
  string = '"'~ [^"]* '"'~ => [[ "" like ]]
  symbol = [!#-'*-~]+ => [[ "" like <uninterned-word> ]]
  object = ws ( float | number | string | symbol ) ws
  sexp   = ws "("~ ( object | sexp )* ")"~ ws => [[ { } like ]]
]=]

: seq>sexp ( seq -- str )
    unparse R/ {\s+/ "(" R/ \s+}/ ")" [ re-replace ] 2bi@ ;

input [ "Input:\n%s\n\n" printf ] [
    sexp>seq dup seq>sexp
    "Native:\n%u\n\nRound trip:\n%s\n" printf
] bi
