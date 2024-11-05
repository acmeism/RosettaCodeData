BEGIN
    # operator that executes a procedure the specified number of times        #
    OP REPEAT = ( INT count, PROC VOID routine )VOID: TO count DO routine OD;

    # make REPEAT a low priority operater                                     #
    PRIO REPEAT = 1;

    # can also create variant that passes the iteration count as a parameter  #
    OP REPEAT = ( INT count, PROC( INT )VOID routine )VOID:
       FOR iteration TO count DO routine( iteration ) OD;

    # PROC to test the REPEAT operator with                                   #
    PROC say something = VOID: print( ( "something", newline ) );

    3 REPEAT say something;

    # PROC to test the variant                                                #
    PROC show squares = ( INT n )VOID:
         print( ( whole( n, 0 ), " ", whole( n * n, 0 ), newline ) );

    3 REPEAT show squares

END
