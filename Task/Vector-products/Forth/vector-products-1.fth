: 3f!    ( &v - ) ( f: x y z - ) dup float+ dup float+ f! f! f! ;

: Vector \ Compiletime: ( f: x y z - ) ( <name> - )
   create here [ 3 floats ] literal allot 3f! ; \ Runtime: ( - &v )

: >fx@    ( &v - ) ( f: - n ) postpone f@ ; immediate
: >fy@    ( &v - ) ( f: - n ) float+ f@ ;
: >fz@    ( &v - ) ( f: - n ) float+ float+ f@ ;
: .Vector ( &v - ) dup >fz@ dup >fy@ >fx@ f. f. f. ;

: Dot*    ( &v1 &v2 - ) ( f - DotPrd )
   2dup >fx@  >fx@ f*
   2dup >fy@  >fy@ f* f+
        >fz@  >fz@ f* f+ ;

: Cross*  ( &v1 &v2 &vResult - )
   >r 2dup >fz@  >fy@ f*
      2dup >fy@  >fz@ f* f-
      2dup >fx@  >fz@ f*
      2dup >fz@  >fx@ f* f-
      2dup >fy@  >fx@ f*
           >fx@  >fy@ f* f-
   r> 3f! ;

: ScalarTriple* ( &v1 &v2 &v3 - ) ( f: - ScalarTriple* )
   >r pad Cross* pad r> Dot* ;

: VectorTriple* ( &v1 &v2 &v3 &vDest - )
   >r swap r@ Cross* r> tuck Cross* ;

 3e   4e   5e Vector A
 4e   3e   5e Vector B
-5e -12e -13e Vector C

cr
cr .( a . b = ) A B Dot* f.
cr .( a x b = ) A B pad Cross* pad .Vector
cr .( a . [b x c] = ) A B C ScalarTriple* f.
cr .( a x [b x c] = ) A B C pad VectorTriple* pad .Vector
