a         ; -> [left right "up" "down"]
next a    ; -> [right "up" "down"]
skip a 2  ; -> ["up" "down"]

a: next a ; -> [right "up" "down"]
head a    ; -> [left right "up" "down"]

copy a                 ; -> [left right "up" "down"]
copy/part a 2          ; -> [left right]
copy/part  skip a 2  2 ; -> ["up" "down"]
