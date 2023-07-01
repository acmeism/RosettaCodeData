S" fsl-util.fs" REQUIRED

: build-identity ( 'p n -- 'p )  \ make an NxN identity matrix
  0 DO
    I 1+ 0 DO
      I J = IF  1.0E0 DUP I J }} F!
      ELSE
        0.0E0 DUP J I }} F!
        0.0E0 DUP I J }} F!
      THEN
    LOOP
  LOOP ;

6 6 float matrix a{{
a{{ 6 build-identity
6 6 a{{ }}fprint
