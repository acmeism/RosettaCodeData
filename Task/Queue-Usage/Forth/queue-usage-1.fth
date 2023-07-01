: cqueue: ( n -- <text>)
    create                                                 \ compile time: build the data structure in memory
        dup
        dup 1- and abort" queue size must be power of 2"
        0 ,                                                \ write pointer "HEAD"
        0 ,                                                \ read  pointer "TAIL"
        0 ,                                                \ byte counter
        dup 1- ,                                           \ mask value used for wrap around
        allot ;                                            \ run time: returns the address of this data structure

\ calculate offsets into the queue data structure
: ->head ( q -- adr )      ;                               \ syntactic sugar
: ->tail ( q -- adr ) cell+   ;
: ->cnt  ( q -- adr ) 2 cells +   ;
: ->msk  ( q -- adr ) 3 cells +   ;
: ->data ( q -- adr ) 4 cells +   ;

: head++ ( q -- )                                         \ circular increment head pointer of a queue
         dup >r ->head @ 1+  r@ ->msk @ and r> ->head ! ;

: tail++ ( q -- )                                         \ circular increment tail pointer of a queue
        dup >r  ->tail @ 1+  r@ ->msk @ and r> ->tail ! ;

: qempty ( q -- flag)
        dup ->head off   dup ->tail off  dup ->cnt  off    \ reset all fields to "off" (zero)
        ->cnt @ 0=  ;                                      \ per the spec qempty returns a flag

: cnt=msk?   ( q -- flag)  dup >r  ->cnt @ r> ->msk @ = ;
: ?empty     ( q -- )     ->cnt @ 0=  abort" queue is empty" ;
: ?full      ( q -- )     cnt=msk? abort" queue is full" ;
: 1+!   ( adr -- )  1 swap +! ;                            \ increment contents of adr
: 1-!   ( adr -- ) -1 swap +! ;          \ decrement contents of adr

: qc@    ( queue -- char )                                 \ fetch next char in queue
       dup >r ?empty                                       \ abort if empty
       r@ ->cnt 1-!                                        \ decr. the counter
       r@ tail++
       r@ ->data  r> ->tail @ + c@ ;                       \ calc. address and fetch the byte


: qc!    ( char queue -- )
       dup >r ?full                                        \ abort if q full
       r@ ->cnt 1+!                                        \ incr. the counter
       r@ head++
       r@ ->data  r> ->head @ + c! ;                       \ data+head = adr, and store the char
