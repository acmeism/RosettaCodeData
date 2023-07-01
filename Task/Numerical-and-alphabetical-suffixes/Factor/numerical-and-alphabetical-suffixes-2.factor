USING: formatting fry grouping kernel literals math
math.functions math.parser math.ranges multiline peg.ebnf
quotations qw sequences sequences.deep splitting strings unicode ;
IN: rosetta-code.numerical-suffixes.ebnf

CONSTANT: test-cases {
    qw{ 2greatGRo 24Gros 288Doz 1,728pairs 172.8SCOre }
    qw{ 1,567 +1.567k 0.1567e-2m }
    qw{ 25.123kK 25.123m 2.5123e-00002G }
    qw{ 25.123kiKI 25.123Mi 2.5123e-00002Gi +.25123E-7Ei }
    qw{ -.25123e-34Vikki 2e-77gooGols }
    qw{
        9! 9!! 9!!! 9!!!! 9!!!!! 9!!!!!! 9!!!!!!! 9!!!!!!!!
        9!!!!!!!!!
    }
}

CONSTANT: metric qw{ K M G T P E Z Y X W V U }

: suffix>quot ( str -- quot )
    dup [ [ 0 1 ] dip subseq >upper metric index 1 + ] dip
    length 1 = [ 3 * '[ 10 _ ^ * ] ] [ 10 * '[ 2 _ ^ * ] ] if ;

: ?f>i ( x -- y/n ) dup >integer 2dup [ number= ] 2dip swap ? ;

GENERIC: commas ( n -- str )
M: integer commas number>string <reversed> 3 group
    [ "," append ] map concat reverse rest ;

M: float commas number>string "." split first2
    [ string>number commas ] dip "." glue ;

EBNF: suffix-num [=[
  sign    = [+-]
  digit   = [0-9]
  triplet = digit digit digit
  commas  = (triplet | digit digit | digit) ([,] triplet)+
  integer = sign? (commas | digit+)
  exp     = [Ee] sign? digit+
  bfloat  = (integer | sign)? [.] digit+ exp?
  float   = (bfloat | integer exp)
  number  = (float | integer) => [[ flatten "" like string>number ]]
  pairs   = [Pp] [Aa] [Ii] [Rr] [s]?           => [[ [ 2 * ] ]]
  dozens  = [Dd] [Oo] [Zz] [e]? [n]? [s]?      => [[ [ 12 * ] ]]
  scores  = [Ss] [Cc] [Oo] [r]? [e]? [s]?      => [[ [ 20 * ] ]]
  gross   = [Gg] [Rr] [o]? [s]? [s]?           => [[ [ 144 * ] ]]
  gg      = [Gg] [Rr] [Ee] [Aa] [Tt] gross     => [[ [ 1728 * ] ]]
  googols = [Gg] [Oo] [Oo] [Gg] [Oo] [Ll] [s]? => [[ [ $[ 10 100 ^ ] * ] ]]
  alpha   = (pairs | dozens | scores | gg | gross | googols)
  numeric = ([KkMmGgPpEeT-Zt-z] [Ii]?) => [[ flatten "" like suffix>quot ]]
  ncompnd = numeric+
  fact    = [!]+ => [[ length [ neg 1 swap <range> product ] curry ]]
  suffix  = (alpha | ncompnd | fact)
  s-num   = number suffix? !(.) =>
            [[ >quotation flatten call( -- x ) ?f>i commas ]]
]=]

: num-alpha-suffix-demo ( -- )
    test-cases [
        dup [ suffix-num ] map
        "Numbers: %[%s, %]\n Result: %[%s, %]\n\n" printf
    ] each ;

MAIN: num-alpha-suffix-demo
