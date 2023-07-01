Red ["Create two-dimensional array at runtime"]

width: to-integer ask "What is the width of the array? "
height: to-integer ask "What is the height of the array? "

                                      ; 2D arrays are just nested blocks in Red.
matrix: copy []                       ; Make an empty block to hold our rows.
loop height [                         ; A loop for each row...
    row: append/dup copy [] 0 width   ; Create a block like [0 0 0 0] if width is 4.
    append/only matrix row            ; Append the row to our matrix as its own block.
]

a: 3
b: 2
matrix/2/4: 27      ; use path syntax to access or assign
matrix/1/1: 99      ; series are 1-indexed in Red; there is no matrix/0/0
matrix/(a)/(a): 10  ; accessing elements with words requires special care
matrix/:b/:b: 33    ; alternative
print mold matrix
