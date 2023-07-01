# procedure to call the Algol 68G evaluate procedure                    #
# the environment of the evaluation will be the caller's environment    #
# with "code", "x" and "y" defined as the procedure parameters          #
PROC ev = ( STRING code, INT x, INT y )STRING: evaluate( code );

BEGIN

    INT  i := 1;
    INT  j := 2;
    REAL x := 4.2;
    REAL y := 0.7164;

    # evaluates "i + j" in the current environment                       #
    print( ( evaluate( "i + j" ), newline ) );

    # evaluates "x + y" in the environment of the procedure body of ev   #
    print( ( ev( "x + y", i, j ), newline ) );

    # evaluates "x + y" in the current environment, so shows a different #
    # result to the previous call                                        #
    print( ( evaluate( "x + y" ), newline ) );

    # prints "code" because code is defined in the environment of the    #
    # call to evaluate (in ev) although it is not defined in this        #
    # environment                                                        #
    print( ( ev( "code", 1, 2 ), newline ) );

    # prints "code + codecode + code" - see above                        #
    print( ( ev( "code + code", 1, 2 ), newline ) )

END

# if this next call was executed, a runtime error would occur as x and y #
# do not exist anymore                                                   #
# ;print( ( evaluate( "x + y" ), newline ) ) #
