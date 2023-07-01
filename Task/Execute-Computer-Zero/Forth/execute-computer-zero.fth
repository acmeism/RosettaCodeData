#! /usr/bin/gforth

\ Execute Computer/Zero

\ reserve 32 cells for memory

CREATE MEMORY 32 cells allot
MEMORY 32 cells erase


\ gets the address of the memory cell with the given index
: mem ( ix - addr )
    cells MEMORY +
;

\ splits a byte into instruction and argument
: instruction ( ix -> arg inst )
    mem @ dup
    32 mod swap
    32 /
;

\ defines a program by giving its name and the 32 memory contents (in binary)
: PROGRAM ( "name" "b01" ... "b31" -- )
    CREATE
        base @ >r 2 base !
        32 0 DO
            BEGIN
                parse-name
            dup 0= WHILE
                2drop refill drop
            REPEAT
            s>number? 2drop ,
        LOOP
        r> base !
    DOES> ( -- n00 ... n31 )
        32 0 DO
            dup @ swap cell+
        LOOP
        drop
;

\ loads 32 bytes from the stack into memory
: >memory ( n00 ... n31 -- )
    -1 31 -DO
        i mem !
    1 -LOOP
;

\ prints accumulator and program counter
: .acc-pc ( acc pc -- acc pc )
    over 3 .r dup 3 .r
;

\ prints the argument
: .x ( x -- x )
    dup 2 .r
;

\ performs one step of the simulation
: step ( acc pc -- acc' pc' )
    .acc-pc ."  : "
    tuck instruction CASE
        0 OF ." NOP " .x drop                          swap 1+      ENDOF
        1 OF ." LDA " .x nip mem @                     swap 1+      ENDOF
        2 OF ." STA " .x over swap mem !               swap 1+      ENDOF
        3 OF ." ADD " .x mem @ + 256 mod               swap 1+      ENDOF
        4 OF ." SUB " .x mem @ - 256 mod               swap 1+      ENDOF
        5 OF ." BRZ " .x over 0= if rot drop else drop swap 1+ then ENDOF
        6 OF ." JMP " .x            rot drop                        ENDOF
        7 OF ." STP " .x drop nip -1                                ENDOF
    ENDCASE
    ."  -> " .acc-pc
;

\ runs the simulation, starting with accumulator zero and program counter zero
: run ( -- acc )
    0 0 cr
    BEGIN
    dup 0>= WHILE
        step cr
    REPEAT
    drop
;


\ the five example programs

PROGRAM 2+2
    00100011 01100100
    11100000 00000010
    00000010 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000

PROGRAM 7*8
    00101100 01101010
    01001100 00101011
    10001101 01001011
    10101000 11000000
    00101100 11100000
    00001000 00000111
    00000000 00000001
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000

PROGRAM Fibonacci
    00101110 01001111
    01101101 01001110
    00101111 01001101
    00110000 10010001
    10101011 01010000
    11000000 00101110
    11100000 00000001
    00000001 00000000
    00001000 00000001
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000
    00000000 00000000

PROGRAM List'
    00101101 01101111
    01000101 01110000
    01000111 00000000
    01001110 00000000
    10101011 01001111
    11000000 00101110
    11100000 00100000
    00000000 00011100
    00000001 00000000
    00000000 00000000
    00000110 00000000
    00000010 00011010
    00000101 00010100
    00000011 00011110
    00000001 00010110
    00000100 00011000

PROGRAM Prisoner
    00000000 00000000
    11100000 00000000
    00100011 10011101
    10110010 00100011
    01011101 10101110
    00100001 01111111
    01000001 11000010
    00100000 01111111
    01000000 11000010
    00100011 01011101
    00100001 01111110
    01100011 01000001
    00100000 01111110
    01100011 01000000
    11000010 00000000
    00000001 00000011


\ runs a program and drops the result
: run-sample-program ( -- )
    >memory run drop
;


\ run the five example programs

2+2       run-sample-program
7*8       run-sample-program
Fibonacci run-sample-program
List'     run-sample-program
Prisoner  run-sample-program

bye
