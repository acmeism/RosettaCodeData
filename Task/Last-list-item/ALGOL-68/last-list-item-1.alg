BEGIN # find the last element after repeatedely adding the sum of the         #
      # two smallest elements and removing them                               #
    PR read "sort.incl.a68" PR                        # row sorting utilities #

    [ 1 : 9 ]INT a := ( 6, 81, 243, 14, 25, 49, 123, 69, 11 );
    INT a count := UPB a;
    WHILE a count > 1 DO
        a QUICKSORT ELEMENTS( LWB a, a count );
        print( ( "Sorted list:" ) );FOR i TO a count DO print( ( " ", whole( a[ i ], 0 ) ) ) OD;
        INT sum = a[ 1 ] + a[ 2 ];
        print( ( "; two smallest: " , whole( a[ 1 ], 0 )
               , " + ", whole( a[ 2 ], 0 )
               , " = ", whole( sum, 0 )
               , newline
               )
             );
        a[ 1 : a count - 2 ] := a[ 3 : a count ];
        a count     -:= 1  ;
        a[ a count ] := sum
    OD;
    print( ( "Last item is ", whole( a[ 1 ], 0 ), ".", newline ) )
END
