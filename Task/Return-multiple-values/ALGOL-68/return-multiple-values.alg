# example mode for returning multiple values from a procedure #
MODE PAIR = STRUCT( STRING name, INT value );

# procedure returning multiple values via a structure #
PROC get pair = ( INT a )PAIR:
    CASE a
    IN #1#    ( "H",  0 )
    ,  #2#    ( "He", 1 )
    ,  #3#    ( "Li", 3 )
    OUT       ( "?",  a )
    ESAC
;

main: (
    # use the result as a whole #
    print( ( get pair( 3 ), newline ) );
    # access the components separately #
    print( ( name OF get pair( 1 ), value OF get pair( 2 ), newline ) )
)
