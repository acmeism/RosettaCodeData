S" fsl-util.fs" REQUIRED
: 3f! 3 SWAP }fput ;
: vector
  CREATE
    HERE 3 DUP FLOAT DUP , * ALLOT SWAP CELL+ }fput
  DOES>
    CELL+ ;
: >fx@ 0 } F@ ;
: >fy@ 1 } F@ ;
: >fz@ 2 } F@ ;
: .Vector 3 SWAP }fprint ;
 0e   0e   0e vector pad  \ NB: your system will be non-standard after this line
\ From here on is identical to the above example
