USING: grouping kernel math math.functions math.matrices
math.vectors prettyprint sequences sequences.generalizations ;

:: a-rotate ( p v a -- seq )
    a cos a sin :> ( ca sa )
    ca 1 - v first3 :> ( t x y z )
    x x t * * ca + x y t * * z sa * - x z t * * y sa * +
    x y t * * z sa * + ca y y t * * + y z t * * x sa * -
    z x t * * y sa * - z y t * * x sa * + ca z z t * * +
    9 narray 3 group p mdotv ;

{ 5 -6 4 } { 8 5 -30 }
dupd [ cross normalize ] [ angle-between ] 2bi a-rotate .
