S" fsl-util.fs" REQUIRED
S" fsl/dynmem.seq" REQUIRED
: F+! ( addr -- ) ( F: r -- )  DUP F@ F+ F! ;
: FSQR ( F: r1 -- r2 ) FDUP F* ;
S" fsl/gaussj.seq" REQUIRED

3 3 float matrix A{{
1e 2e 3e  4e 5e 6e  7e 8e 9e  3 3 A{{ }}fput
3 3 float matrix B{{
3e 3e 3e  2e 2e 2e  1e 1e 1e  3 3 B{{ }}fput
float dmatrix C{{    \ result

A{{ 3 3 B{{ 3 3 & C{{ mat*
3 3 C{{ }}fprint
