main:
(
    # Just get a random price between 0 and 1 #
    # srand(time(NIL)); #
    REAL price := random;
    REAL tops := 0.06;
    REAL std val := 0.10;

    # Conditionals are a little odd here "(price-0.001 < tops AND
    price+0.001 > tops)" is to check if they are equal. Stupid
    C floats, right?   :) #
    WHILE ( price>tops OR (price-0.001 < tops AND price+0.001 > tops) ) AND tops<=1.01
    DO
        tops+:=0.05;

        IF std val < 0.26 THEN
                std val +:= 0.08
        ELIF std val < 0.50 THEN
                std val +:= 0.06
        ELSE
                std val +:= 0.04
        FI;

        IF std val > 0.98 THEN
                std val := 1.0
        FI
    OD;

    printf(($"Value :   "z.2dl,"Converted to standard :   "z.2dl$, price, std val))
)
