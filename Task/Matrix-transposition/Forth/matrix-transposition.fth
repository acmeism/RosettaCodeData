S" fsl-util.fs" REQUIRED
S" fsl/dynmem.seq" REQUIRED
: F+! ( addr -- ) ( F: r -- )  DUP F@ F+ F! ;
: FSQR ( F: r1 -- r2 ) FDUP F* ;
S" fsl/gaussj.seq" REQUIRED

5 3 float matrix a{{
1e 2e 3e  4e 5e 6e  7e 8e 9e  10e 11e 12e  13e 14e 15e  5 3 a{{ }}fput
float dmatrix b{{

a{{ 5 3 & b{{ transpose
3 5 b{{ }}fprint
