arena: make block! 1000           ;; create a block to hold series
loop 10 [                         ;; fill with some series
   append arena make binary! 100
]
clear arena ;; removes references to binary series
recycle     ;; recycle unused memory (manualy)
arena: none ;; remove reference to the arena's block
;; allocated arena's memory will be released on next GC run
;; to list internal memory pools:
stats/show
