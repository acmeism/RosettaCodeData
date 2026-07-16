Rebol [
    title: "Rosetta code: Element-wise operations"
    file:  %Element-wise_operations.r3
    url:   https://rosettacode.org/wiki/Element-wise_operations
]

matrix-op: function/with [
    "Create an element-wise matrix operator function from a binary op."
    bin-op [any-function!] "Binary operator"
][
    function/with [
        "Apply a binary matrix operation element-wise."
        a [block! integer! decimal! percent!] "Left operand (matrix or scalar)"
        b [block! integer! decimal! percent!] "Right operand (matrix or scalar)"
    ][
        case [
            all [block? a  block? b] [
                ;; matrix op matrix: apply op to matching elements row by row
                i: 1 map-each row-a a [
                    row-b: b/(++ i)
                    j: 1 map-each x row-a [op x row-b/(++ j)]
                ]
            ]
            all [scalar? a  block? b] [
                ;; scalar op matrix: apply op with scalar as left arg to each element
                map-each row b [map-each x row [op a x]]
            ]
            all [block? a  scalar? b] [
                ;; matrix op scalar: apply op with scalar as right arg to each element
                map-each row a [map-each x row [op x b]]
            ]
            'else [cause-error 'user 'message ["Expected at least one matrix."]]
        ]
    ] compose [op: quote (:bin-op)]
][
    scalar?: function [
        "Return true if obj is a numeric scalar (integer, float, or percent)."
        obj [any-type!]
    ][
        find #(typeset! [integer! decimal! percent!]) type? obj
    ]
]

mat-add: matrix-op :add
mat-sub: matrix-op :subtract
mat-mul: matrix-op :multiply
mat-div: matrix-op :divide
mat-pow: matrix-op :power

a: [[1 2][3  4][ 5  6]]
b: [[7 8][9 10][11 12]]

; test:
prin "a + b = "   probe new-line/all mat-add a b   on
prin "a - b = "   probe new-line/all mat-sub a b   on
prin "a - 10 = "  probe new-line/all mat-sub a 10  on
prin "10 - b = "  probe new-line/all mat-sub 10 b  on
prin "a x b = "   probe new-line/all mat-mul a b   on
prin "a x 10 = "  probe new-line/all mat-mul a 10  on
prin "a / b = "   probe new-line/all mat-div a b   on
prin "a / 10 = "  probe new-line/all mat-div a 10  on
prin "a ^^ 2 = "  probe new-line/all mat-pow b 2   on
