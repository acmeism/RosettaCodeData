Rebol [
    title: "Rosetta code: Reduced row echelon form"
    file:  %Reduced_row_echelon_form.r3
    url:   https://rosettacode.org/wiki/Reduced_row_echelon_form
]

to-reduced-row-echelon-form: function [
    "Transforms a matrix into Reduced Row Echelon Form (RREF) in-place."
    M [block!] "Block of blocks, where each inner block represents a row. (modified)"
][
    for-r: 1                   ;; Current pivot row index
    lead:  1                   ;; Current pivot column index
    row-count: length? M       ;; Total number of rows
    column-count: length? M/1  ;; Total number of columns

    while [for-r <= row-count] [
        ;; If we've exhausted all columns, the matrix is fully reduced
        if column-count <= lead [break]

        ;; Find the first row at or below for-r that has a non-zero entry in the lead column
        i: for-r
        while [M/:i/:lead = 0] [
            ++ i
            ;; If we've scanned all rows without finding a pivot, move to the next column
            if row-count = i [
                i: for-r
                if column-count = lead [break]  ; No more columns to try — exit
                ++ lead
            ]
        ]

        ;; Swap row i with the current pivot row (for-r) so the pivot is in position
        swap M/:i M/:for-r

        ;; Normalise the pivot row by dividing through by the pivot value,
        ;; making the leading entry in this row equal to 1
        pivot: M/:for-r/:lead
        if pivot <> 0 [
            row-r: for-r
            repeat col column-count [
                M/:row-r/:col: M/:row-r/:col / pivot
            ]
        ]

        ;; Eliminate all other entries in the lead column by subtracting
        ;; the appropriate multiple of the pivot row from every other row
        repeat ii row-count [
            if ii <> for-r [
                factor: M/:ii/:lead  ; How much of the pivot row to subtract
                repeat col column-count [
                    M/:ii/:col: M/:ii/:col - (factor * M/:for-r/:col)
                ]
            ]
        ]

        ++ lead    ;; Advance to the next pivot column
        ++ for-r   ;; Advance to the next pivot row
    ]
    M  ;; Return the reduced matrix
]

probe to-reduced-row-echelon-form [
    [ 1    2   -1   -4 ]
    [ 2    3   -1   -11]
    [-2    0   -3    22]
]
