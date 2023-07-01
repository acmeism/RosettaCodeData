USING: accessors formatting grouping io kernel lists lists.lazy
math math.functions math.primes prettyprint sequences
tools.memory.private tools.time ;



! ==========={[ Cyclops data type and operations ]}=============

TUPLE: cyclops left right n max ;

: <cyclops> ( -- cyclops ) 1 1 1 9 cyclops boa ;

: >cyclops< ( cyclops -- right left n )
    [ right>> ] [ left>> ] [ n>> ] tri ;

M: cyclops >integer >cyclops< 1 + 10^ * + ;

: >blind ( cyclops -- n ) >cyclops< 10^ * + ;

: next-zeroless ( 9199 -- 9211 )
    dup 10 mod 9 < [ 10 /i next-zeroless 10 * ] unless 1 + ;

: right++ ( cyclops -- cyclops' )
    [ next-zeroless ] change-right ; inline

: left++ ( cyclops -- cyclops' )
    [ next-zeroless ] change-left [ 9 /i ] change-right ;

: n++ ( cyclops -- cyclops' )
    [ 1 + ] change-n [ 10 * 9 + ] change-max ;

: change-both ( cyclops quot -- cyclops' )
    [ change-left ] keep change-right ; inline

: expand ( cyclops -- cyclops' )
    dup max>> 9 /i 1 + '[ _ + ] change-both n++ ;

: carry ( cyclops -- cyclops' )
    dup [ left>> ] [ max>> ] bi < [ left++ ] [ expand ] if ;

: succ ( cyclops -- next-cyclops )
    dup [ right>> ] [ max>> ] bi < [ right++ ] [ carry ] if ;



! ============{[ List definitions & operations ]}===============

: lcyclops ( -- list ) <cyclops> [ succ ] lfrom-by ;

: lcyclops-int ( -- list ) lcyclops [ >integer ] lmap-lazy ;

: lprime-cyclops ( -- list )
    lcyclops-int [ prime? ] lfilter ;

: lblind-prime-cyclops ( -- list )
    lcyclops [ >integer prime? ] lfilter
    [ >blind prime? ] lfilter ;

: reverse-digits ( 123 -- 321 )
    0 swap [ 10 /mod rot 10 * + swap ] until-zero ;

: lpalindromic-prime-cyclops ( -- list )
    lcyclops [ [ left>> ] [ right>> ] bi reverse-digits = ]
    lfilter [ >integer prime? ] lfilter ;

: first>1e7 ( list -- elt index )
    0 lfrom lzip [ first >integer 10,000,000 > ] lfilter car
    first2 [ >integer ] dip [ commas ] bi@ ;



! ====================={[ OUTPUT ]}=============================

: first50 ( list -- )
  50 swap ltake [ >integer ] lmap list>array 10 group
  simple-table. ;

:: show ( desc list -- )
    desc desc "First 50 %s numbers:\n" printf
    list [ first50 nl ] [
        first>1e7
        "First %s number > 10,000,000: %s - at (zero based) index: %s.\n\n\n" printf
    ] bi ;

"cyclops" lcyclops-int show
"prime cyclops" lprime-cyclops show
"blind prime cyclops" lblind-prime-cyclops show
"palindromic prime cyclops" lpalindromic-prime-cyclops show

! Extra stretch?
"One billionth cyclops number:" print
999,999,999 lcyclops lnth >integer commas print
