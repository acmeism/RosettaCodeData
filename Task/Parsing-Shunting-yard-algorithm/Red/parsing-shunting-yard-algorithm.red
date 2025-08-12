Red [ "Shunting-Yard Infix to RPN - Hinjo, July 2025" ]

; no error handling, assumed expr is spaced and correct
shunting: function [expr [string!] /trace] [
    output: copy []  ops: copy []
    prec: #["+"  2  "-"  2  "*"  3  "/"  3  "^^"  4 ] ; precedence
    asc:  #["+" "L" "-" "L" "*" "L" "/" "L" "^^" "R"] ; association

    stats: function [t] [ ; display basic tracing
        if not trace [exit]
        print [t "|" pad act 35 "|" pad (form output) 30 pad/left (reverse form ops) 15]
    ]

    tokens: split expr " "
    while [not empty? tokens] [
        tok: first tokens  tokens: next tokens
        case [
            find "0123456789" tok [ ; add numbers to output
                act: "(a) Add number to output"  append output tok  stats tok
            ]
            find "(" tok [ ; push "(" to stack
                act: "(b) Push ( to stack"  append ops tok  stats tok
            ]
            find ")" tok [ ; pop stack to output until "("
                while [(last ops) <> "("] [ ; assume input is correct!
                    act: "(c) Pop op to output"  append output (take/last ops)  stats tok
                ]
                act: "(d) Discard ( from stack"  take/last ops  stats " " ; should be ")"
            ]
            find "+-*/^^" tok [
                ; Pop higher or equal-left operators from stack
                while [not empty? ops] [
                    last-op: last ops
                    if (none? last-op) [break]
                    if (last-op = "(") [break] ; skip, we're in ()
                    if (prec/:last-op < prec/:tok) [break]
                    if (asc/:last-op <> "L") [break]
                    act: "(e) Pop higher/equal op to output"  append output take/last ops  stats " "
                ]
                ; Now push current operator
                act: "(f) Push op to stack"  append ops tok  stats tok
            ]
        ]
    ]
    ; flush the stack to output
    act: "Finished. Flush ops:" stats " "
    while [not empty? ops] [
        act: "(g) Pop op to output"  append output (take/last ops)  stats " "
    ]
    ; return output
    form output
]

; assumed input is space separated! ('^' is escape char!)
print "Some test for input and output with trace:"
print ["^/" s: "3 + 4 * 2 / ( 1 - 5 ) ^^ 2 ^^ 3"]           shunting/trace s
print ["^/" s: "( ( 1 + 2 ) ^^ ( 3 + 4 ) ) ^^ ( 5 + 6 )"]   shunting/trace s
print ["^/" s: "1 + 2 * 3 / 4 + 5"]                         shunting/trace s

check: function [s t u][
    print [pad s 40 "|" pad t 30 "|" pad u 30 "|" t = u]
]

print "^/Print input, validation and the output:"
s: "1 + 2 * 3 / 4 + 5"                        t: "1 2 3 * 4 / + 5 +"            u: shunting s  check s t u
s: "3 + 4 * 2 / ( 1 - 5 ) ^^ 2 ^^ 3"          t: "3 4 2 * 1 5 - 2 3 ^^ ^^ / +"  u: shunting s  check s t u
s: "( ( 1 + 2 ) ^^ ( 3 + 4 ) ) ^^ ( 5 + 6 )"  t: "1 2 + 3 4 + ^^ 5 6 + ^^"      u: shunting s  check s t u
s: "( 1 + 2 ) ^^ ( 3 + 4 ) ^^ ( 5 + 6 )"      t: "1 2 + 3 4 + 5 6 + ^^ ^^"      u: shunting s  check s t u
s: "( ( 3 ^^ 4 ) ^^ 2 ^^ 9 ) ^^ 2 ^^ 5"       t: "3 4 ^^ 2 9 ^^ ^^ 2 5 ^^ ^^"   u: shunting s  check s t u
s: "( 1 + 4 ) * ( 5 + 3 ) * 2 * 3"            t: "1 4 + 5 3 + * 2 * 3 *"        u: shunting s  check s t u
s: "1 * 2 * 3 * 4"                            t: "1 2 * 3 * 4 *"                u: shunting s  check s t u
s: "1 + 2 + 3 + 4"                            t: "1 2 + 3 + 4 +"                u: shunting s  check s t u
s: "( 1 + 2 ) ^^ ( 3 + 4 )"                   t: "1 2 + 3 4 + ^^"               u: shunting s  check s t u
s: "( 5 ^^ 6 ) ^^ 7"                          t: "5 6 ^^ 7 ^^"                  u: shunting s  check s t u
s: "5 ^^ 4 ^^ 3 ^^ 2"                         t: "5 4 3 2 ^^ ^^ ^^"             u: shunting s  check s t u
s: "1 + 2 + 3"                                t: "1 2 + 3 +"                    u: shunting s  check s t u
s: "1 ^^ 2 ^^ 3"                              t: "1 2 3 ^^ ^^"                  u: shunting s  check s t u
s: "( 1 ^^ 2 ) ^^ 3"                          t: "1 2 ^^ 3 ^^"                  u: shunting s  check s t u
s: "1 - 1 + 3"                                t: "1 1 - 3 +"                    u: shunting s  check s t u
s: "3 + 1 - 1"                                t: "3 1 + 1 -"                    u: shunting s  check s t u
s: "1 - ( 2 + 3 )"                            t: "1 2 3 + -"                    u: shunting s  check s t u
s: "4 + 3 + 2"                                t: "4 3 + 2 +"                    u: shunting s  check s t u
s: "5 + 4 + 3 + 2"                            t: "5 4 + 3 + 2 +"                u: shunting s  check s t u
s: "5 * 4 * 3 * 2"                            t: "5 4 * 3 * 2 *"                u: shunting s  check s t u
s: "5 + 4 - ( 3 + 2 )"                        t: "5 4 + 3 2 + -"                u: shunting s  check s t u
s: "3 - 4 * 5"                                t: "3 4 5 * -"                    u: shunting s  check s t u
s: "3 * ( 4 - 5 )"                            t: "3 4 5 - *"                    u: shunting s  check s t u
s: "( 3 - 4 ) * 5"                            t: "3 4 - 5 *"                    u: shunting s  check s t u
s: "4 * 2 + 1 - 5"                            t: "4 2 * 1 + 5 -"                u: shunting s  check s t u
s: "4 * 2 / ( 1 - 5 ) ^^ 2"                   t: "4 2 * 1 5 - 2 ^^ /"           u: shunting s  check s t u
