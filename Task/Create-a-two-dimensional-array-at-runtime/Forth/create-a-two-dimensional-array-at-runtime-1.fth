: cell-matrix
  create ( width height "name" ) over ,  * cells allot
  does> ( x y -- addr ) dup cell+ >r  @ * + cells r> + ;

5 5 cell-matrix test

36 0 0 test !
0 0 test @ .  \ 36
