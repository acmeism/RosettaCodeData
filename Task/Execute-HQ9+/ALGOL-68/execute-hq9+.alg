# the increment-only accumulator #
INT hq9accumulator := 0;

# interpret a HQ9+ code string #
PROC hq9 = ( STRING code )VOID:
    FOR i TO UPB code
    DO
        CHAR   op = code[ i ];
        IF op = "Q" OR op = "q"
        THEN
            # display the program #
            print( ( code, newline ) )
        ELIF op = "H" OR op = "h"
        THEN
            print( ( "Hello, world!", newline ) )
        ELIF op = "9"
        THEN
            # 99 bottles of beer #
            FOR bottles FROM 99 BY -1 TO 1 DO
                 STRING bottle count = whole( bottles, 0 ) + IF bottles > 1 THEN " bottles" ELSE " bottle" FI;
                 print( ( bottle count, " of beer on the wall", newline ) );
                 print( ( bottle count, " bottles of beer.",    newline ) );
                 print( ( "Take one down, pass it around,",     newline ) );
                 IF bottles > 1
                 THEN
                     print( ( whole( bottles - 1, 0 ), " bottles of beer on the wall.", newline, newline ) )
                 FI
            OD;
            print( ( "No more bottles of beer on the wall.", newline ) )
        ELIF op = "+"
        THEN
            # increment the accumulator #
            hq9accumulator +:= 1
        ELSE
            # unimplemented operation #
            print( ( """", op, """ not implemented", newline ) )
        FI
    OD;


# test the interpreter #
BEGIN
    STRING code;
    print( ( "HQ9+> " ) );
    read( ( code, newline ) );
    hq9( code )
END
