USING: accessors kernel literals math math.statistics
prettyprint sequences ;

CONSTANT: mask64 $[ 1 64 shift 1 - ]
CONSTANT: mask32 $[ 1 32 shift 1 - ]
CONSTANT: const 0x2545F4914F6CDD1D

! Restrict seed value to positive integers.
PREDICATE: positive < integer 0 > ;
ERROR: seed-nonpositive seed ;

TUPLE: xorshift* { state positive initial: 1 } ;

: <xorshift*> ( seed -- xorshift* )
    dup positive? [ seed-nonpositive ] unless
    mask64 bitand xorshift* boa ;

: twiddle ( m n -- n ) dupd shift bitxor mask64 bitand ;

: next-int ( obj -- n )
    dup state>> -12 twiddle 25 twiddle -27 twiddle tuck swap
    state<< const * mask64 bitand -32 shift mask32 bitand ;

: next-float ( obj -- x ) next-int 1 32 shift /f ;

! ---=== Task ===---
1234567 <xorshift*> 5 [ dup next-int . ] times

987654321 >>state
100,000 [ dup next-float 5 * >integer ] replicate nip
histogram .
