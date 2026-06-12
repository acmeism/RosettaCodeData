BEGIN # Example of L-System evaluation and interpretation                    #

    PR read "lsystem.incl.a68" PR               # include L-System utilities #

    # task rabbit population example                                         #
    LSYSTEM rabbit population = ( "I", ( "I" -> "M"
                                       , "M" -> "MI"
                                       )
                                );
    INT    young := 0, old := 0;
    STRING result = rabbit population EVAL 5;
    result INTERPRET ( ( CHAR c )VOID: IF c = "I" THEN young +:= 1 ELSE old +:= 1 FI );

    print( ( "After 5 iterations there are ", whole( old, 0 ), " old rabbits and "
           , whole( young, 0 ), " young ones (", result, ")", newline
           )
         )

END
