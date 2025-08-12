Red [ "RPN to Infix - Hinjo, 26 July 2025" ]

rpn-to-infix: func [exp [string!]] [
    blk: load exp ; convert into block
    stack: copy []
    stack-op: copy []

    printstack: func [] [
        foreach x stack [
            prin rejoin [x " "]
        ]
    ]
    push: func [val op] [
        append stack val
        append stack-op op
    ]
    pop: function [] [
        val: take/last stack
        op: take/last stack-op
        compose [(val) (op)]
    ]

    foreach tok blk [
        print rejoin [printstack]
        case [
            number? tok [push tok 'n]
            find [+ - * / ^] tok [
                b: pop
                a: pop
                if tok = '^ [
                    if string? a/1 [
                        if find "+-*/^^" a/2
                            [a/1: rejoin ["(" a/1 ")"]]
                    ]
                    if string? b/1 [
                        if find "+-*/" b/2
                            [b/1: rejoin ["(" b/1 ")"]]
                    ]
                ]
                if find "*/" tok [
                    if string? a/1 [
                        if find "+-" a/2
                            [a/1: rejoin ["(" a/1 ")"]] ]
                    if string? b/1 [
                        if find "+-" b/2
                            [b/1: rejoin ["(" b/1 ")"]] ] ]

                expr: rejoin compose [""(rejoin [(a/1)" "(tok)" "(b/1)])""]
                push expr tok
            ]
        ]
    ]
    printstack print ""
]

; in Red, "^" is an escape char, so, it must be written as ^^
rpn-to-infix "3 4 2 * 1 5 - 2 3 ^^ ^^ / +"
rpn-to-infix "1 2 + 3 4 + ^^ 5 6 + ^^"
