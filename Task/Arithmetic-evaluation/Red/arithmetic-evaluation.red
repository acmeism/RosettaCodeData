Red [ "Arithmetic Evaluator - Hinjo, August 2025"
      {Using a Modified Shunting-Yard algorithm to produce S-Expression as the AST
       and a simple S-Expression evaluator (recursive).}
]

s-expr: function [expr [string!] /trace] [
    output: copy []  ops: copy []
    prec: #["+" 2 "-" 2 "*" 3 "/" 3 "^^" 4]
    asc:  #["+" "L" "-" "L" "*" "L" "/" "L" "^^" "R"]

    stats: function [t] [
        if not trace [exit]
        print [t "|" pad act 25 "|" pad (mold output) 45 pad/left (reverse form ops) 15]
    ]

    make-node: function [op] [
        right: take/last output
        left: take/last output
        node: load rejoin ["[" op " " mold left " " mold right "]"]
        node
    ]

    tokens: split expr " "
    while [not empty? tokens] [
        tok: first tokens  tokens: next tokens
        case [
            find "0123456789" tok [
                act: "1.Push number as value"
                append output load tok
                stats tok
            ]
            tok = "(" [
                act: "2.Push ( to ops"
                append ops tok
                stats tok
            ]
            tok = ")" [
                while [(last ops) <> "("] [
                    act: "3.Pop op, build node"
                    append/only output make-node take/last ops
                    stats tok
                ]
                act: "4.Discard ("
                take/last ops
                stats tok
            ]
            find "+-*/^^" tok [

                popping: func [][
                    if empty? ops [return false]
                    if none? last ops [return false]
                    last-op: last ops
                    if last-op = ")" [return false]
                    if none? prec/:last-op [return false]
                    return (prec/:last-op > prec/:tok)
                        or ((prec/:last-op = prec/:tok)
                            and (asc/:tok = "L"))
                ]

                while [popping] [
                    act: "5.Pop op, build node"
                    append/only output make-node take/last ops
                    stats tok
                ]
                act: "6.Push current op"
                append ops tok
                stats tok
            ]
        ]
    ]
    act: "7.Final flush ops"
    stats " "
    while [not empty? ops] [
        act: "8.Pop op, build node"
        append/only output make-node take/last ops
        stats " "
    ]
    output/1
]

; basic s-expression evaluator
s-eval: function [expr][
    either block? expr [
        op: expr/1
        a: s-eval expr/2
        b: s-eval expr/3
        case [
            op = '+ [a + b]
            op = '- [a - b]
            op = '* [a * b]
            op = '/ [a / b]
            op = '^ [a ** b]
            true [do make error! rejoin ["Unknown operator: " mold op]]
        ]
    ][
        expr ; base case: just a number
    ]
]

print "Simple test:"
s: "1 + 2"                                 se: s-expr s  print [pad s 40 " ==> " pad (mold se) 45 " = " s-eval se]
s: "1 + 2 * 3"                             se: s-expr s  print [pad s 40 " ==> " pad (mold se) 45 " = " s-eval se]
s: "( 1 + 2 ) * 3"                         se: s-expr s  print [pad s 40 " ==> " pad (mold se) 45 " = " s-eval se]
s: "( 1 + 2 * 3 ) / 2"                     se: s-expr s  print [pad s 40 " ==> " pad (mold se) 45 " = " s-eval se]

print "^/Complex ones:"
s: "3 + 4 * 2 / ( 1 - 5 ) ^^ 2 ^^ 3"       se: s-expr s  print [pad s 40 " ==> " pad (mold se) 45 " = " s-eval se]
s: "( 1 + 2 * 3 ) ^^ 2 / 6 ^^ 2 ^^ 3 - 1"  se: s-expr s  print [pad s 40 " ==> " pad (mold se) 45 " = " s-eval se]

print "^/Some test for input and output with trace:"
print ["^/" s: "3 + 4 * 2 / ( 1 - 5 ) ^^ 2 ^^ 3"]           se: s-expr/trace s  print [s " ==> " mold se " = " s-eval se]
print ["^/" s: "( ( 1 + 2 ) ^^ ( 3 + 4 ) ) ^^ ( 5 + 6 )"]   se: s-expr/trace s  print [s " ==> " mold se " = " s-eval se]
print ["^/" s: "1 + 2 * 3 / 4 + 5"]                         se: s-expr/trace s  print [s " ==> " mold se " = " s-eval se]
