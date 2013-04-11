PROC non square = (INT n)INT: n + ENTIER(0.5 + sqrt(n));

main: (

    # first 22 values (as a list) has no squares: #
    FOR i TO 22 DO
        print((whole(non square(i),-3),space))
    OD;
    print(new line);

    # The following check shows no squares up to one million:  #
    FOR i TO 1 000 000 DO
        REAL j = sqrt(non square(i));
        IF j = ENTIER j THEN
            put(stand out, ("Error: number is a square:", j, new line));
            stop
        FI
    OD
)
