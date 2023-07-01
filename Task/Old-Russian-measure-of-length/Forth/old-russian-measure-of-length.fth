create units s" kilometer" 2, s" meter" 2, s" centimeter" 2, s" tochka" 2, s" liniya" 2, s" diuym" 2, s" vershok" 2, s" piad" 2, s" fut" 2, s" arshin" 2, s" sazhen" 2, s" versta" 2, s" milia" 2,
create values 1000.0e f, 1.0e f, 0.01e f, 0.000254e f, 0.00254e f, 0.0254e f, 0.04445e f, 0.1778e f, 0.3048e f, 0.7112e f, 2.1336e f, 1066.8e f, 7467.6e f,
: unit ( u1 -- caddr u1 )
    units swap 2 cells * + 2@ ;
: myval ( u1 -- caddr u1 )
    values swap 1 cells * + f@ ;
: 2define create 0 , 0 , ;

2define ch_u
variable mlt
variable theunit
: show ( chosen_unit chosen_mutliplier -- )
    ch_u 2!
    mlt f!
    13 0 DO
    ch_u 2@ i unit compare if
    else mlt f@ f. i unit type cr ." ==========="  cr
        i myval theunit f!
        13 0 DO
            ." 	" i unit type ." : " theunit f@ i myval f/ mlt f@ f* f. cr
        LOOP
    then
    LOOP cr ;
1e s" meter" show
20e s" versta" show
10e s" milia" show
