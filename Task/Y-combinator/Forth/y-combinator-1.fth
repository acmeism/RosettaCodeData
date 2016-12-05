\ Address of an xt.
variable 'xt
\ Make room for an xt.
: xt, ( -- ) here 'xt !  1 cells allot ;
\ Store xt.
: !xt ( xt -- ) 'xt @ ! ;
\ Compile fetching the xt.
: @xt, ( -- ) 'xt @ postpone literal postpone @ ;
\ Compile the Y combinator.
: y, ( xt1 -- xt2 ) >r :noname @xt, r> compile, postpone ; ;
\ Make a new instance of the Y combinator.
: y ( xt1 -- xt2 ) xt, y, dup !xt ;
