:: quadratic-equation ( a b c -- x1 x2 )
    b sq a c * 4 * - sqrt :> sd
    b 0 <
    [ b neg sd + a 2 * / ]
    [ b neg sd - a 2 * / ] if :> x
    x c a x * / ;
