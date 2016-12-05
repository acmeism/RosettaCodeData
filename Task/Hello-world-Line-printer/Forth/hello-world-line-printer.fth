\ No operating system, embedded device, printer output example

defer emit                                   \ deferred words in Forth are a place holder for an
                                             \ execution token (XT) that is assigned later.
                                             \ When executed the deferred word simply runs that assigned routine

: type ( addr count -- )                     \ type a string uses emit
       bounds ?do  i c@ emit   loop ;        \ type is used by all other text output words in the system

HEX
: CR   ( -- )  0A emit 0D emit ;             \ send a carriage return, linefeed pair with emit

\ memory mapped I/O addresses for the printer port
B02E   constant scsr                         \ serial control status register
B02F   constant scdr                         \ serial control data register

: printer-emit ( char -- )                   \ output 'char' to the printer serial port
         begin   scsr C@ 80 and  until       \ loop until the port shows a ready bit
         scdr C!                             \ C! (char store) writes a byte to an address
         20 ms ;                             \ 32 mS delay to prevent over-runs

: console-emit ( char -- )   ...             \ defined in the Forth system, usually assembler

\ vector control words
: >console     ['] console-emit is EMIT ;     \ assign the execution token of console-emit to EMIT
: >printer     ['] printer-emit is EMIT ;     \ assign the execution token of printer-emit to EMIT
