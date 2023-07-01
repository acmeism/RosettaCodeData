\ Written in ANS-Forth; tested under VFX.
\ Requires the novice package: http://www.forth.org/novice.html
\ The following should already be done:
\ include novice.4th

\ This is already in the novice package, so it is not really necessary to compile the code provided here.

\ ******
\ ****** This is our array sort. We are using the heap-sort because it provides consistent times and it is not recursive.
\ ****** This code was ported from C++ at: http://www.snippets.24bytes.com/2010/06/heap-sort.html
\ ****** Our array record size must be a multiple of W. This is assured if FIELD is used for creating the record.
\ ****** The easiest way to speed this up is to rewrite EXCHANGE in assembly language.
\ ******

marker HeapSort.4th

macro: exchange ( adrX adrY size -- )   \ the size of the record must be a multiple of W
    begin  dup while                    \ -- adrX adrY remaining
        over @  fourth @                \ -- adrX adrY remaining Y X
        fourth !  fourth !              \ -- adrX adrY remaining
        rot w +  rot w +  rot w -
        repeat
    3drop ;

\ All of these macros use the locals from SORT, and can only be called from SORT.

macro: adr ( index -- adr )
    recsiz *  array + ;

macro: left ( x -- y )      2*  1+ ;

macro: right ( x -- y )     2*  2 + ;

macro: heapify ( x -- )
    dup >r  begin   \ r: -- great
        dup left    dup limit < if      dup adr  rover adr  'comparer execute if    rdrop  dup >r   then then  drop
        dup right   dup limit < if      dup adr  r@ adr     'comparer execute if    rdrop  dup >r   then then  drop
        dup r@ <> while
            adr  r@ adr  recsiz exchange
            r@ repeat
    drop rdrop ;

macro: build-max-heap ( -- )
    limit 1- 2/  begin  dup 0>= while  dup heapify  1- repeat drop ;

: sort { array limit recsiz 'comparer -- }
    recsiz  [ w 1- ] literal  and  abort" *** SORT: record size must be a multiple of the cell size ***"
    build-max-heap
    begin  limit while  -1 +to limit
        0 adr  limit adr  recsiz exchange
        0 heapify  repeat ;

\ The SORT locals:
\ array             \ the address of the 0th element
\ limit             \ the number of records in the array
\ recsiz            \ the size of a record in the array     \ this must be a multiple of W (FIELD assures this)
\ 'comparer         \ adrX adrY -- X>Y?

\ Note for the novice:
\ This code was originally written with colon words rather than macros, and using items rather than local variables.
\ After it was debugged, it was changed to use macros and locals so that it would be fast and reentrant.
\ One of the reasons why the heap-sort was chosen is because it is not recursive, which allows macros to be used.
\ Using macros allows the data (array, limit, recsiz, 'comparer) to be held in locals rather than items, which is reentrant.


\ ******
\ ****** This tests SORT.
\ ******

create aaa  2 , 9 , 3 , 6 , 1 , 4 , 5 , 7 , 0 , 8 ,

: print-aaa ( limit -- )
    cells aaa +  aaa do  I @ .  w +loop ;

: int> ( adrX adrY -- X>Y? )
    swap @  swap @  > ;

: test-sort ( limit -- )
    cr  dup print-aaa
    aaa  over  w  ['] int>  sort
    cr  print-aaa ;

10 test-sort
