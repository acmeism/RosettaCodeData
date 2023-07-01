: F-start,  here 1 0 dup , ;
: F-next,   over + swap
            dup 0> IF  dup , true  ELSE  false  THEN ;

: computed-table  ( compile: 'start 'next / run: i -- x )
   create
      >r execute
      BEGIN  r@ execute not  UNTIL  rdrop
   does>
       swap cells + @ ;

' F-start, ' F-next,  computed-table fibonacci 2drop
here swap - cell/ Constant #F/64   \ # of fibonacci numbers generated

16 fibonacci . 987  ok
#F/64 . 93  ok
92 fibonacci . 7540113804746346429  ok   \ largest number generated.
