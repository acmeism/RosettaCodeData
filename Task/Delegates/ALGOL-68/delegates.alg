# An Algol 68 approximation of delegates                                #

# The delegate mode - the delegate is a STRUCT with a single field      #
# that is a REF PROC STRING. If this is NIL, it doesn't implement       #
# thing                                                                 #
MODE DELEGATE  = STRUCT( REF PROC STRING thing );


# A delegator mode that will invoke the delegate's thing method         #
# - if there is a delegate and the delegate has a thing method          #
MODE DELEGATOR = STRUCT( REF DELEGATE delegate
                       , PROC( REF DELEGATE )STRING thing
                       );

# constructs a new DELEGATE with the specified PROC as its thing        #
# Algol 68 HEAP is like "new" in e.g. Java, but it can't take           #
# parameters, so this PROC does the equivalent                          #
PROC new delegate = ( REF PROC STRING thing )REF DELEGATE:
    BEGIN
        REF DELEGATE result = HEAP DELEGATE;
        thing OF result := thing;

        result
    END # new delegate #
;

# constructs a new DELEGATOR with the specified DELEGATE                #
PROC new delegator = ( REF DELEGATE delegate )REF DELEGATOR:
    HEAP DELEGATOR := ( delegate
                      , # anonymous PROC to invoke the delegate's thing #
                        ( REF DELEGATE delegate )STRING:
                            IF delegate IS REF DELEGATE(NIL)
                            THEN
                                # we have no delegate #
                                "default implementation"

                            ELIF thing OF delegate IS REF PROC STRING(NIL)
                            THEN
                                # the delegate doesn't have an implementation #
                                "default implementation"

                            ELSE
                                # the delegate can thing #
                                thing OF delegate

                            FI
                      )
;


# invokes the delegate's thing via the delagator                        #
# Because the PROCs of a STRUCT don't have an equivalent of e.g. Java's #
# "this", we have to explicitly pass the delegate as a parameter        #
PROC invoke thing = ( REF DELEGATOR delegator )STRING:
    # the following is Algol 68 for what would be written in Java as    #
    #                           "delegator.thing( delegator.delegate )" #
    ( thing OF delegator )( delegate OF delegator )
;

main:
(

    print( ( "No delegate           : "
           , invoke thing( new delegator( NIL ) )
           , newline
           , "Delegate with no thing: "
           , invoke thing( new delegator( new delegate( NIL ) ) )
           , newline
           , "Delegate with a thing : "
           , invoke thing( new delegator( new delegate( HEAP PROC STRING := STRING: ( "delegate implementation" ) ) ) )
           , newline
           )
         )

)
