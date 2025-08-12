Red [ "RPN Eval - Hinjo, July 25, 2025" ]
rpn-exec: func [exp [string!]] [
    stack: copy []
    blk: load exp ; convert into block
    foreach tok blk [
        print [mold stack tok]
        case [
            number? tok [append stack tok]
            find [+ - * / ^] tok [
                if (length? stack) < 2 [
                    print "Error: Two operands required!" exit ]
                if tok = '^ [tok: '**]
                b: take/last stack
                a: take/last stack
                append stack do compose [a (tok) b]
            ]
        ]
    ]
]
; in Red, "^" is an escape char, so, it must be written as ^^
rpn-exec "3 4 2 * 1 5 - 2 3 ^^ ^^ / +"
