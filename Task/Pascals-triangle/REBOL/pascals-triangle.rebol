Rebol [
    title: "Rosetta code: Pascal's triangle"
    file:  %Pascal's_triangle.r3
    url:   https://rosettacode.org/wiki/Pascal's_triangle
]

pascal-triangle: function [
    "Prints the first N rows of Pascal's triangle"
    rows [integer!] "Number of rows to print"
][
    row: #(u32![ 1 ])     ;; current row, starts with [1]
    loop rows [
        print row
        left:  copy row
        right: copy row
        insert left  0    ;; shift right  → [0 1 2 1]
        append right 0    ;; shift left   → [1 2 1 0]
        row: left + right ;; element-wise sum → next row
    ]
]

pascal-triangle 7
