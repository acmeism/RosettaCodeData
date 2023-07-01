require fsl-util.fs
require fsl/complex.fs

: abs= 1E-12 F~ ;
: clamp-to-0 FDUP 0E0 abs= IF FDROP 0E0 THEN ;
: zclamp-to-0
  clamp-to-0 FSWAP
  clamp-to-0 FSWAP ;
: .roots
  1+ 2 DO
    I . ." : "
    I 0 DO
      1E0 2E0 PI F* I S>F F* J S>F F/ polar> zclamp-to-0 z. SPACE
    LOOP
    CR
  LOOP ;
3 SET-PRECISION
5 .roots
