#! /usr/bin/gforth

\ Priority queue

10 CONSTANT INITIAL-CAPACITY

\ creates a new empty queue
: new-queue ( -- addr )
    2 INITIAL-CAPACITY 3 * + cells allocate throw
    INITIAL-CAPACITY over !
    0 over cell + !
;

\ deletes a queue
: delete-queue ( addr -- )
    free throw
;

: queue-capacity ( addr -- n )
    @
;

\ the number of elements in the queue
: queue-size ( addr -- n )
    cell + @
;

: resize-queue ( addr -- addr )
    dup queue-capacity 2 * dup >r 3 * 2 + cells resize throw
    r> over !
;

: ix->addr ( addr ix -- addr )
    3 * 2 + cells +
;

: ix! ( p x y addr ix -- )
    ix->addr
    tuck 2 cells + !
    tuck cell + !
    !
;

: ix@ ( addr ix -- p x y )
    ix->addr
    dup @ swap
    cell + dup @ swap
    cell + @
;

: ix->priority ( addr ix -- p )
    ix->addr @
;

: ix<->ix ( addr ix ix' -- )
    -rot over swap  ( ix' addr addr ix ) ( )
    2over swap 2>r  ( ix' addr addr ix ) ( addr ix' )
    2dup ix@ 2>r >r ( ix' addr addr ix ) ( addr ix' x y p )
    2>r             ( ix' addr )         ( addr ix' x y p addr ix )
    swap ix@        ( p' x' y' )         ( addr ix' x y p addr ix )
    2r> ix!         ( )                  ( addr ix' x y p )
    r> 2r> 2r> ix!  ( )                  ( )
;

: ix-parent ( ix -- ix' )
    dup 0> IF
        1- 2/
    THEN
;

: ix-left-son ( ix -- ix' )
    2* 1+
;

: ix-right-son ( ix -- ix' )
    2* 2 +
;

: swap? ( addr ix ix' -- f )
    rot >r           ( ix ix' )                  ( addr )
    2dup             ( ix ix' ix ix' )           ( addr )
    r> tuck swap     ( ix ix' ix addr addr ix' ) ( )
    ix->priority >r  ( ix ix' ix addr )          ( p' )
    tuck swap        ( ix ix' addr addr ix )     ( p' )
    ix->priority r>  ( ix ix' addr p p' )        ( )
    > IF
        -rot ix<->ix
        true
    ELSE
        2drop drop
        false
    THEN
;

: ix? ( addr ix -- f )
    swap queue-size <
;

: bubble-up ( addr ix -- )
    2dup dup ix-parent swap ( addr ix addr ix' ix )
    swap? IF                ( addr ix )
        ix-parent recurse
    ELSE
        2drop
    THEN
;

: bubble-down ( addr ix -- )
    2dup ix-right-son ix? IF
        2dup ix-left-son ix->priority >r
        2dup ix-right-son ix->priority r> < IF
            2dup dup ix-right-son swap? IF
                ix-right-son recurse
            ELSE
                2drop
            THEN
        ELSE
            2dup dup ix-left-son swap? IF
                ix-left-son recurse
            ELSE
                2drop
            THEN
        THEN
    ELSE
        2dup ix-left-son ix? IF
            2dup dup ix-left-son swap? IF
                ix-left-son recurse
            ELSE
                2drop
            THEN
        ELSE
            2drop
        THEN
    THEN
;

\ enqueues an element with priority p and payload x y into queue addr
: >queue ( p x y addr -- addr )
    dup queue-capacity over queue-size =
    IF
        resize-queue
    THEN
    dup >r
    dup queue-size
    ix!
    r>
    1 over cell + +!
    dup dup queue-size 1- bubble-up
;

\ dequeues the element with highest priority
: queue> ( addr -- p x y )
    dup queue-size 0= IF
        1 throw
    THEN
    dup 0 ix@ 2>r >r dup >r
    dup dup queue-size 1- ix@ r> 0 ix!
    dup cell + -1 swap +!
    0 bubble-down
    r> 2r>
;

\ dequeues elements and prints them until the queue is empty
: drain-queue ( addr -- )
    dup queue-size 0> IF
        dup queue>
        rot
        . ." - " type cr
        recurse
    ELSE
        drop
    THEN
;


\ example

new-queue
>r 3 s" Clear drains"   r> >queue
>r 4 s" Feed cat"       r> >queue
>r 5 s" Make tea"       r> >queue
>r 1 s" Solve RC tasks" r> >queue
>r 2 s" Tax return"     r> >queue

drain-queue
