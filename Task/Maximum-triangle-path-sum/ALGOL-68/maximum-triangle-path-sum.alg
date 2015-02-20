# create a triangular array of the required values #

    [ 1]INT row  1 :=                           ( 55 );
    [ 2]INT row  2 :=                         ( 94, 48 );
    [ 3]INT row  3 :=                        ( 95, 30, 96 );
    [ 4]INT row  4 :=                      ( 77, 71, 26, 67 );
    [ 5]INT row  5 :=                     ( 97, 13, 76, 38, 45 );
    [ 6]INT row  6 :=                   ( 07, 36, 79, 16, 37, 68 );
    [ 7]INT row  7 :=                  ( 48, 07, 09, 18, 70, 26, 06 );
    [ 8]INT row  8 :=                ( 18, 72, 79, 46, 59, 79, 29, 90 );
    [ 9]INT row  9 :=               ( 20, 76, 87, 11, 32, 07, 07, 49, 18 );
    [10]INT row 10 :=             ( 27, 83, 58, 35, 71, 11, 25, 57, 29, 85 );
    [11]INT row 11 :=            ( 14, 64, 36, 96, 27, 11, 58, 56, 92, 18, 55 );
    [12]INT row 12 :=          ( 02, 90, 03, 60, 48, 49, 41, 46, 33, 36, 47, 23 );
    [13]INT row 13 :=         ( 92, 50, 48, 02, 36, 59, 42, 79, 72, 20, 82, 77, 42 );
    [14]INT row 14 :=       ( 56, 78, 38, 80, 39, 75, 02, 71, 66, 66, 01, 03, 55, 72 );
    [15]INT row 15 :=      ( 44, 25, 67, 84, 71, 67, 11, 61, 40, 57, 58, 89, 40, 56, 36 );
    [16]INT row 16 :=    ( 85, 32, 25, 85, 57, 48, 84, 35, 47, 62, 17, 01, 01, 99, 89, 52 );
    [17]INT row 17 :=   ( 06, 71, 28, 75, 94, 48, 37, 10, 23, 51, 06, 48, 53, 18, 74, 98, 15 );
    [18]INT row 18 := ( 27, 02, 92, 23, 08, 71, 76, 84, 15, 52, 92, 63, 81, 10, 44, 10, 69, 93 );

[18]REF[]INT triangle := ( row  1, row  2, row  3, row  4, row  5, row  6
                         , row  7, row  8, row  9, row 10, row 11, row 12
                         , row 13, row 14, row 15, row 16, row 17, row 18
                         );

PROC max = ( INT a, INT b )INT: IF a > b THEN a ELSE b FI;

# working backwards, we replace the elements of each row with the sum of that #
# element and the maximum of the two elements below it.                       #
# That destroys the triangle but leaves element [1][1] equal to the required  #
# maximum                                                                     #


FOR row FROM UPB triangle - 1 BY -1 TO 1
DO
    FOR element FROM 1 TO UPB triangle[row]
    DO
        # the elements "under" triangle[row][element] are                     #
        # triangle[row+1][element] and triangle[row+1][element+1]             #
        triangle[row][element]
            +:= max( triangle[row+1][element], triangle[row+1][element+1] )
    OD
OD;

print( ( triangle[1][1], newline ) )
