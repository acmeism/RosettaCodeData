# returns "text" with leading non-printing characters removed #
PROC trim leading whitespace = ( STRING text )STRING:
BEGIN

    INT pos := LWB text;

    WHILE
        IF pos > UPB text
        THEN
            FALSE
        ELSE
            text[ pos ] <= " "
        FI
    DO
        pos +:= 1
    OD;

    text[ pos : ]
END; # trim leading whitespace #

# returns "text" with trailing non-printing characters removed #
PROC trim trailing whitespace = ( STRING text )STRING:
BEGIN

    INT pos := UPB text;

    WHILE
        IF pos < LWB text
        THEN
            FALSE
        ELSE
            text[ pos ] <= " "
        FI
    DO
        pos -:= 1
    OD;

    text[ : pos ]
END; # trim trailing whitespace #

# returns "text" with leading and trailing non-printing characters removed #
PROC trim whitespace = ( STRING text )STRING:
BEGIN
    trim trailing whitespace( trim leading whitespace( text ) )
END; # trim whitespace #


main:(
    STRING test = "   leading and trailing spaces surrounded this text   ";

    print( ( "trim  leading: """ + trim leading whitespace ( test ) + """", newline ) );
    print( ( "trim trailing: """ + trim trailing whitespace( test ) + """", newline ) );
    print( ( "trim     both: """ + trim whitespace         ( test ) + """", newline ) )
)
