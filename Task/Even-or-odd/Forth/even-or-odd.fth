: odd?  ( n -- ? ) 1 and ;
: even? ( n -- ? ) odd? 0= ;

\ Every value not equal to zero is considered true. Only zero is considered false.
