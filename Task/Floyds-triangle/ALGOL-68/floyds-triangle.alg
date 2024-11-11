# procedure to print a Floyd's Triangle with n lines                        #
PROC floyds triangle = ( INT n )VOID:
BEGIN

    # the triangle should be left aligned with the individual numbers     #
    # right-aligned with only one space before the number in the final    #
    # row                                                                 #

    # calculate the number of the highest number that will be printed     #
    # ( the sum of the integers 1, 2, ... n )                             #
    INT max number = ( n * ( n + 1 ) ) OVER 2;

    # determine the widths required to print the numbers of the final row #
    [ n ]INT widths;
    INT number := max number + 1;
    FOR col FROM n BY -1 TO 1 DO
        widths[ col ] := - ( UPB whole( number -:= 1, 0 ) + 1 )
    OD;

    # print the triangle                                                  #
    INT element := 0;
    FOR row TO n DO
        FOR col TO row DO
            print( ( whole( element +:= 1, widths[ col ] ) ) )
        OD;
        print( ( newline ) )
    OD

END; # floyds triangle #

floyds triangle(  5 );
print( ( newline ) );
floyds triangle( 14 )
