S" fsl-util.fs" REQUIRED
S" fsl/dynmem.seq" REQUIRED

cell darray p{

: sgn
  DUP 0 > IF
    DROP 1
  ELSE 0 < IF
    -1
  ELSE
    0
  THEN THEN ;
: arr-swap {: addr1 addr2 | tmp -- :}
  addr1 @ TO tmp
  addr2 @ addr1 !
  tmp addr2 ! ;
: perms {: n xt | my-i k s -- :}
  & p{ n 1+ }malloc malloc-fail? ABORT" perms :: out of memory"
  0 p{ 0 } !
  n 1+ 1 DO
    I NEGATE p{ I } !
  LOOP
  1 TO s
  BEGIN
    1 n 1+ DO
      p{ I } @ ABS
    -1 +LOOP
    n 1+ s xt EXECUTE
    0 TO k
    n 1+ 2 DO
      p{ I } @ 0 < ( flag )
      p{ I } @ ABS  p{ I 1- } @ ABS  > ( flag flag )
      p{ I } @ ABS p{ k } @ ABS > ( flag flag flag )
      AND AND IF
        I TO k
      THEN
    LOOP
    n 1 DO
      p{ I } @ 0 > ( flag )
      p{ I } @ ABS  p{ I 1+ } @ ABS  > ( flag flag )
      p{ I } @ ABS  p{ k } @ ABS  > ( flag flag flag )
      AND AND IF
        I TO k
      THEN
    LOOP
    k IF
      n 1+ 1 DO
        p{ I } @ ABS  p{ k } @ ABS  > IF
          p{ I } @ NEGATE p{ I } !
        THEN
      LOOP
      p{ k } @ sgn k + TO my-i
      p{ k } p{ my-i } arr-swap
      s NEGATE TO s
    THEN
  k 0 = UNTIL ;
: .perm ( p0 p1 p2 ... pn n s )
  >R
  ." Perm: [ "
  1 DO
    . SPACE
  LOOP
  R> ." ] Sign: " . CR ;

3 ' .perm perms CR
4 ' .perm perms
