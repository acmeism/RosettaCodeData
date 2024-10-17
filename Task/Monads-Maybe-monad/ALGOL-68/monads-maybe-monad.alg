BEGIN

    # This is a translation of the Javascript sample, main differences are because Algol 68    #
    # is strongly typed and "on-the-fly" constructon of functions is not really possible -     #
    # we need to define a STRUCT where Javascript would just construct a new function.         #
    # As Algol 68 does not allow procedure overloading, we use custom operators (which do      #
    # allow overloading) so the techniques used here could be extended to procedures with      #
    # signatures other than PROC(REAL)REAL                                                     #
    # The comments are generally the same as in the javascript original, changed as necessary  #
    # to reflect Algol 68...                                                                   #

    # START WITH SOME SIMPLE (UNSAFE) PARTIAL FUNCTIONS:                                       #

    # error in n < 0 #
    PROC unsafe reciprocal = (REAL n)REAL: 1 / n;
    # error if n < 0 #
    PROC unsafe root       = (REAL n)REAL: sqrt(n);
    # error if n <= 0 #
    PROC unsafe log        = (REAL n)REAL: ln(n);


    # NOW DERIVE SAFE VERSIONS OF THESE SIMPLE FUNCTIONS:                                      #
    # These versions use a validity test, and return a wrapped value                           #
    # with a boolean is valid property as well as a value property                             #

    MODE SAFEFUNCTION = STRUCT( PROC(REAL)REAL fn, PROC(REAL)BOOL fn safety check );
    MODE MAYBE        = STRUCT( BOOL is valid, REAL value );

    SAFEFUNCTION safe reciprocal = ( unsafe reciprocal, ( REAL n )BOOL: n /= 0 );
    SAFEFUNCTION safe root       = ( unsafe root,       ( REAL n )BOOL: n >= 0 );
    SAFEFUNCTION safe log        = ( unsafe log,        ( REAL n )BOOL: n >  0 );

COMMENT
    the original Javascript contains this:

    // THE DERIVATION OF THE SAFE VERSIONS USED THE 'UNIT' OR 'RETURN'
    // FUNCTION OF THE MAYBE MONAD

    // Named maybe() here, the unit function of the Maybe monad wraps a raw value
    // in a datatype with two elements: .isValid (Bool) and .value (Number)

    // a -> Ma
    function maybe(n) {
        return {
            isValid: (typeof n !== 'undefined'),
            value: n
        };
    }

    However Algol 68 is strongly typed, so the type (MODE) of the function parameters
    cannot be anything other than REAL. We therefore use "MAYBE( TRUE, n )" instead.
COMMENT

    # THE PROBLEM FOR FUNCTION NESTING (COMPOSITION) OF THE SAFE FUNCTIONS                     #
    # IS THAT THEIR INPUT AND OUTPUT TYPES ARE DIFFERENT                                       #

    # Our safe versions of the functions take simple numeric arguments (i.e. REAL), but return #
    # wrapped results. If we feed a wrapped result as an input to another safe function, the   #
    # compiler will object. The solution is to write a higher order                            #
    # function (sometimes called 'bind' or 'chain') which handles composition, taking a        #
    # a safe function and a wrapped value as arguments,                                        #

    # The 'bind' function of the Maybe monad:                                                  #
    # 1. Applies a 'safe' function directly to the raw unwrapped value, and                    #
    # 2. returns the wrapped result.                                                           #

    # Ma -> (a -> Mb) -> Mb #
    # defined as an operator to allow overloading to other PROC modes                          #
    PRIO BIND = 1;
    OP   BIND = (MAYBE maybe n, SAFEFUNCTION mf )MAYBE:
        IF is valid OF maybe n THEN mf CALL ( value OF maybe n ) ELSE maybe n FI;
    # we need an operator to call the wrapped function                                         #
    PRIO CALL = 1;
    OP   CALL = ( SAFEFUNCTION f, REAL value )MAYBE:
         BEGIN
             BOOL is valid = ( fn safety check OF f )( value );
             MAYBE( is valid, IF is valid THEN ( fn OF f )( value ) ELSE value FI )
         END; # CALL #

    # Using the bind function, we can nest applications of safe functions,                     #
    # without the compiler choking on unexpectedly wrapped values returned from                #
    # other functions of the same kind. E.g.:                                                  #
#   REAL root one over four                                                                    #
#      = value OF ( MAYBE( TRUE, 4 ) BIND safe reciprocal BIND safe root );                    #
#   print( ( root one over four, newline ) ); #
    # -> 0.5 #

    # We can compose a chain of safe functions (of any length) with a simple foldr/reduceRight #
    # which starts by 'lifting' the numeric argument into a Maybe wrapping,                    #
    # and then nests function applications (working from right to left)                        #
    # again, defined as an operator here to allow extension to other PROC modes                #
    # also, as Algol 68 doesn't have builtin foldr/reduceRight, we need a loop...              #
    PRIO SAFECOMPOSE = 1;
    OP   SAFECOMPOSE = ( []SAFEFUNCTION lst functions, REAL value )MAYBE:
         BEGIN
             MAYBE result := MAYBE( TRUE, value );
             FOR fn pos FROM UPB lst functions BY -1 TO LWB lst functions DO
                 result := result BIND lst functions[ fn pos ]
             OD;
             result
         END; # SAFECOMPOSE #

    # TEST INPUT VALUES WITH A SAFELY COMPOSED VERSION OF LOG(SQRT(1/X))                       #

    PROC safe log root reciprocal = ( REAL n )MAYBE:
         BEGIN
             # this declaration is requied for Algol 68G 2.8                                   #
             []SAFEFUNCTION function list = ( safe log, safe root, safe reciprocal );
             function list SAFECOMPOSE n
         END; # safe log root reciprocal #

    # Algol 68 doesn't have a builtin map operator, we could define one here but we can just   #
    # use a loop for the purposes of this task...                                              #
    REAL e = exp( 1 );
    []REAL test values = ( -2, -1, -0.5, 0, 1 / e, 1, 2, e, 3, 4, 5 );

    STRING prefix := "[";
    FOR test pos FROM LWB test values TO UPB test values DO
        MAYBE result = safe log root reciprocal( test values[ test pos ] );
        print( ( prefix, IF is valid OF result THEN fixed( value OF result, -12, 8 ) ELSE "undefined" FI ) );
        IF test pos MOD 4 = 0 THEN print( ( newline ) ) FI;
        prefix := ", "
    OD;
    print( ( "]", newline ) )

END
