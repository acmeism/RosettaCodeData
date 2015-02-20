\ Written in ANS-Forth; tested under VFX.
\ Requires the novice package: http://www.forth.org/novice.html
\ The following should already be done:
\ include novice.4th
\ include list.4th

marker TopRank.4th

\ This demonstrates how I typically use lists. A program such as this does not need any explicit iteration, so it is more like Factor than C.
\ I would define high-level languages as those that allow programs to be written without explicit iteration. Iteration is a major source of bugs.
\ The C library has QSORT that hides iteration, but user-written code very rarely uses this technique, and doesn't in the TopRank example.


\ ******
\ ****** The following defines our data-structure.
\ ****** Pretty much every struct definition has these basic functions.
\ ******

list
    w field .name       \ string
    w field .id         \ string
    w field .salary     \ integer
    w field .dept       \ string
constant employee

: init-employee ( name id salary department node -- node )
    init-list >r
    hstr    r@ .dept !
            r@ .salary !
    hstr    r@ .id !
    hstr    r@ .name !
    r> ;

: new-employee ( name id salary dept -- node )
    employee alloc
    init-employee ;

: <kill-employee> ( node -- )
    dup .name @     dealloc
    dup .id @       dealloc
    dup .dept @     dealloc
    dealloc ;

: kill-employee ( head -- )
    each[  <kill-employee>  ]each ;

: <clone-employee> ( node -- new-node )
    clone-node
    dup .name @     hstr    over .name !
    dup .id @       hstr    over .id !
    dup .dept @     hstr    over .dept ! ;

: clone-employee ( head -- new-head )
    nil
    swap each[  <clone-employee> link  ]each ;

: <show-employee> ( node -- )
    dup .id @       count type  4 spaces
    dup .dept @     count type  4 spaces
    dup .salary @   .           4 spaces
    dup .name @     count type  cr
    drop ;

: show-employee ( head -- )
    cr
    each[  <show-employee>  ]each ;


\ ******
\ ****** The following code is specific to the query that we want to do in this example problem.
\ ******

: employee-dept-salary ( new-node node -- new-node ? )                      \ for use by FIND-PRIOR or INSERT-ORDERED
    2dup
    .dept @ count   rot .dept @ count   compare     ?dup if  A>B =  nip exit then
    .salary @       over .salary @      < ;

: <top> ( n rank current-dept head node -- n rank current-dept head )
    2>r                         \ -- n rank current-dept
    dup count  r@ .dept @ count  compare  A=B <> if                         \ we have a new department
        2drop                                                               \ discard RANK and CURRENT-DEPT
        0  r@ .dept @  then                                                 \ start again with a new RANK and CURRENT-DEPT
    rover rover > if                                                        \ if N > RANK then it is good
        r> r>  over             \ -- n rank current-dept node head node
        <clone-employee> link   \ -- n rank current-dept node head
        >r >r  then             \ -- n rank current-dept
    swap 1+  swap                                                           \ increment RANK
    rdrop  r> ;                 \ -- n rank current-dept head

: top ( n head -- new-head )    \ make a new list of the top N salary earners in each dept      \ requires that list be sorted by dept-salary
    >r
    0  c" xxx"  nil             \ -- n rank current-dept new-head           \ initially for an invalid department
    r>  ['] <top>  each
    3nip ;


\ ******
\ ****** The following is a test of the program using sample data.
\ ******

nil  ' employee-dept-salary
c" Tyler Bennett"       c" E10297"  32000  c" D101"     new-employee  insert-ordered
c" John Rappl"          c" E21437"  47000  c" D050"     new-employee  insert-ordered
c" George Woltman"      c" E00127"  53500  c" D101"     new-employee  insert-ordered
c" Adam Smith"          c" E63535"  18000  c" D202"     new-employee  insert-ordered
c" Claire Buckman"      c" E39876"  27800  c" D202"     new-employee  insert-ordered
c" David McClellan"     c" E04242"  41500  c" D101"     new-employee  insert-ordered
c" Rich Holcomb"        c" E01234"  49500  c" D202"     new-employee  insert-ordered
c" Nathan Adams"        c" E41298"  21900  c" D050"     new-employee  insert-ordered
c" Richard Potter"      c" E43128"  15900  c" D101"     new-employee  insert-ordered
c" David Motsinger"     c" E27002"  19250  c" D202"     new-employee  insert-ordered
c" Tim Sampair"         c" E03033"  27000  c" D101"     new-employee  insert-ordered
c" Kim Arlich"          c" E10001"  57000  c" D190"     new-employee  insert-ordered
c" Timothy Grove"       c" E16398"  29900  c" D190"     new-employee  insert-ordered
drop  constant test-data

cr .( N = 0 )
0 test-data top  dup show-employee  kill-employee

cr .( N = 1 )
1 test-data top  dup show-employee  kill-employee

cr .( N = 2 )
2 test-data top  dup show-employee  kill-employee

cr .( N = 3 )
3 test-data top  dup show-employee  kill-employee

test-data kill-employee
