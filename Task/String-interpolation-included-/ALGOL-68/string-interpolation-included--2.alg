BEGIN
    FILE str file;
    STRING mhl;
    associate( str file, mhl );

    STRING extra := "little";
    TO 2 DO
        putf( str file, ( $"Mary had a "g" lamb."$, extra ) );
        print( ( "1 result is: {{", mhl, "}}", newline ) );
        mhl := "";
        "supposedlly-" +=: extra
    OD;

    FORMAT extraf := $"little"$;
    TO 2 DO
        putf( str file, ( $"Mary had a "f(extraf)" lamb."$ ) );
        print( ( "2 result is: {{", mhl, "}}", newline ) );
        mhl := "";
        extraf := $"medium-sized"$
    OD
END
