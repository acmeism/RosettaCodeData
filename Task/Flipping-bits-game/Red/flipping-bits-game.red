Red []
random/seed   now/time/precise                 ;; start random generator
kRows: kCols: 3                                ;; define board size, 3x3 upto 9x9 possible
                                               ;; create series of 3 empty blocks:
loop kRows [ append/only board: []  copy [] ]  ;; ( this is actually a bit tricky, normally you'd have to use "copy" [] inside a loop )

kValid: "1A"                                    ;; generate string for input validation "321ABC"
loop (kRows - 1 ) [insert kValid (first kValid) + 1 ]
loop (kCols - 1 ) [append kValid (last kValid) + 1 ]

repeat row kRows [ loop kCols [ append board/:row -1 + random 2 ] ] ;; fill board with random 0 / 1
;;--------------------------------------
xorme: func ['val][ set val 1 xor get val ]           ;; function: flip the given board position
;;--------------------------------------
flip: func [ what [string!] ] [                       ;; flip complete row or column  of board
 row:  -48 + to-integer first  what                   ;; convert string to integer row/column index
 if row <= kRows  [ repeat col kCols [ xorme board/:row/:col] return 0 ]
 repeat row2 kRows [ xorme board/:row2/(row - 16)]
]
;;--------------------------------------
showboard: func [title [string!] b] [                           ;; function: show board name + board or target
  prin [title newline newline" " letter: #"A" ]                 ;; ( prin doesn't print newline at end )
  loop ( kCols - 1) [ prin ["" letter: letter + 1] ] print ""   ;; print column letters
  repeat row kRows [                                            ;; print one row
    prin row                                                    ;; first print row number
    repeat col kCols [ prin ["" b/:row/:col ]]
    print ""
  ]
]

showboard "Target" target: copy/deep board               ;; create target as copy from board and show
random kvalid
repeat pos 3 [flip copy/part skip kvalid pos 1]          ;; now flip board 3 times at random row/column

run: -1
forever [
  showboard "Board" board
  if board = target [ Print ["You solved it in" run + 1 "move(s) !" ] halt ]          ;; count last move
  print [newline "moves:" run: run + 1   ]                                            ;; show moves taken so far
  until [ find kvalid inp: uppercase ask "Enter Row No or Column Letter to flip ?" ]  ;; read valid input character
  flip  inp
]                                                         ;; 42 lines :- )
