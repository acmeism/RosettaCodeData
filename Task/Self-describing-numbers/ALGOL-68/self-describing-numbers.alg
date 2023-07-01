BEGIN

    # return TRUE if number is self describing, FALSE otherwise #
    OP SELFDESCRIBING = ( INT number )BOOL:
       BEGIN

           [10]INT counts := ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 );
           INT n          := number;
           INT digits     := 0;

           # count the occurances of each digit #
           WHILE
               n /= 0
           DO
               digits +:= 1;
               counts[ ( n MOD 10 ) + 1 ] +:= 1;
               n OVERAB 10
           OD;

           # construct the number that the counts would describe, #
           # if the number was self describing                    #

           INT described number := 0;
           FOR i TO digits
           DO
               described number *:= 10;
               described number +:= counts[ i ]
           OD;

           # if the described number is the input number, #
           # it is self describing #
           ( number = described number )
       END; # SELFDESCRIBING #

main: (

    FOR i TO 100 000 000
    DO
        IF SELFDESCRIBING i
        THEN
            print( ( i, " is self describing", newline ) )
        FI
    OD
)

END
