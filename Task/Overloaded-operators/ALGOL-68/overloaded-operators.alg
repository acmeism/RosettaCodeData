BEGIN
    # Algol 68 allows operator overloading, both of existing operators and new ones  #
    # Programmer defined operators can be a "bold word" (uppercase word) or a symbol #
    # Symbolic operators can be one or two characters, optionally followed by := or  #
    # =:, =: can also be defined as an operator (Allowed in Algol 68G, possibly not  #
    # in other implementations)                                                      #
    # the characters allowed in a symbolic operator depends on the implementation    #
    # but would include +, -, *, /, <, =, >                                          #

    # define a new TOSTRING operator and overload it #
    OP TOSTRING = ( INT  n )STRING:
       whole( n, 0 ); # returns a string representation of n in the minimum width #
    OP TOSTRING = ( BOOL bv )STRING: IF bv THEN "true" ELSE "false" FI;
    # overide a standard operator #
    INT a = 10, b = 11, c = 21;
    BEGIN
        OP + = ( INT na, INT nb )INT: na - nb;
        # + between strings is a standard operator that does string concation #
        print( ( TOSTRING a, " ""+"" ", TOSTRING b, " = ", TOSTRING ( a + b ), " = " ) );
        print( ( TOSTRING c, "? ", TOSTRING ( ( a + b ) = c ), newline ) )
    END;
    # same print, with the stndard + #
    print( ( TOSTRING a, "  +  ", TOSTRING b, " = ", TOSTRING ( a + b ), " = " ) );
    print( ( TOSTRING c, "? ", TOSTRING ( ( a + b ) = c ), newline ) );
    # overload + to allow a BOOL to be added to an INT #
    OP + = ( INT nv, BOOL bv )INT: IF bv THEN nv + 1 ELSE nv FI;
    print( ( TOSTRING a, " ""+"" ", TOSTRING ( a = 10 ), " = ", TOSTRING ( a + ( a = 10 ) ), newline ) )
END
