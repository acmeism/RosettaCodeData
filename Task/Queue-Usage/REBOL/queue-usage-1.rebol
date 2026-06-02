queue: [a]         ;== [a]
append queue [b c] ;== [a b c]
take queue         ;== a
take/last queue    ;== c
queue              ;== [b]
length? queue      ;== 1
insert queue 'A    ;== [b] because insert returns position after insertion
append queue 'C    ;== [A b C] because append returns position at head
