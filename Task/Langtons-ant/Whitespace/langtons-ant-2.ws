; For easier access, the direction vector is stored at the end of the heap.
push 10003 dup push  100 store
push 1 sub dup push   -1 store
push 1 sub dup push -100 store
push 1 sub dup push    1 store

0:  ; Initialize the grid.
    push 1 sub dup push 0 store
    dup push 0 swap sub jn 0
    push 5050 ; Start the ant at the center.

1:  ; Make sure the ant's in bounds.
    dup push 100 mod jn 2
    dup push 100 div jn 2
    push 100 copy 1 copy 1 mod sub jz 2
    push 100 copy 1 copy 1 div sub jz 2

    swap copy 1 load      ; Get current cell state.
    push 1 add push 2 mod ; Invert it.
    copy 2 copy 1  store  ; Then store it back.
    push 2 mul push 5 add add push 4 mod ; Determine new direction.
    swap copy 1 push 10000 add load add  ; Update position accordingly.
    jump 1

2:  ; Initialize a counter and flow into the printer.
    pop dup sub

3:  ; Iterate over the cells.
    dup load push 32 add ochr ; Print ' ' for off, '!' for on.
    push 1 add dup    ; Increment the counter.
    push 100 mod jz 5 ; Branch at the end of a row.
    4:
        dup push 10000 sub jn 3 ; Go again unless counter is 10000.
        pop exit ; All done, exit clean.

5:  ; Print a newline and jump back to the counter check.
    push 10 ochr jump 4
