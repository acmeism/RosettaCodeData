USING: grouping io kernel lists lists.lazy math math.functions
math.primes prettyprint sequences ;

: 2^-1^ ( n -- 2^n -1^n ) dup 2^ -1 rot ^ ;
: jacobsthal ( m -- n ) 2^-1^ - 3 / ;
: jacobsthal-lucas ( m -- n ) 2^-1^ + ;
: as-list ( quot -- list ) 0 lfrom swap lmap-lazy ; inline
: jacobsthals ( -- list ) [ jacobsthal ] as-list ;
: lucas-jacobthals ( -- list ) [ jacobsthal-lucas ] as-list ;
: prime-jacobsthals ( -- list ) jacobsthals [ prime? ] lfilter ;
: show ( n list -- ) ltake list>array 5 group simple-table. nl ;

: oblong ( -- list )
    jacobsthals dup cdr lzip [ product ] lmap-lazy ;

"First 30 Jacobsthal numbers:" print
30 jacobsthals show

"First 30 Jacobsthal-Lucas numbers:" print
30 lucas-jacobthals show

"First 20 Jacobsthal oblong numbers:" print
20 oblong show

"First 20 Jacobsthal primes:" print
20 prime-jacobsthals ltake [ . ] leach
