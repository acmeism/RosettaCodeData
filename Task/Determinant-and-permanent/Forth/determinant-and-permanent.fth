S" fsl-util.fs" REQUIRED
S" fsl/dynmem.seq" REQUIRED
[UNDEFINED] defines [IF] SYNONYM defines IS [THEN]
S" fsl/structs.seq" REQUIRED
S" fsl/lufact.seq" REQUIRED
S" fsl/dets.seq" REQUIRED
S" permute.fs" REQUIRED

VARIABLE the-mat
: add-perm ( p0 p1 p2 ... pn n s -- )
  DROP  \ sign
  1E
  1 DO
    the-mat @ SWAP 1- I 1- }} F@ F*
  LOOP
  DROP  \ Dummy element because we're using 1-based indexing
  F+ ;
: permanent ( len mat -- ) ( F: -- perm )
  the-mat !
  0E
  ['] add-perm perms ;

3 SET-PRECISION
2 2 float matrix m2{{
1e 2e  3e 4e  2 2 m2{{ }}fput
lumatrix lmat
3 3 float matrix m3{{
2e 9e 4e  7e 5e 3e  6e 1e 8e  3 3 m3{{ }}fput

lmat 2 lu-malloc
m2{{ lmat lufact
lmat det F. 2 m2{{ permanent F. CR
lmat lu-free

lmat 3 lu-malloc
m3{{ lmat lufact
lmat det F. 3 m3{{ permanent F. CR
lmat lu-free
