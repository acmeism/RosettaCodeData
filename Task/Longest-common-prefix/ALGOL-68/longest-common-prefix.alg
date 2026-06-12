# find the longest common prefix of two strings #
PRIO COMMONPREFIX = 1;
OP   COMMONPREFIX = ( STRING a, b )STRING:
    BEGIN
        INT a pos := LWB a; INT a max = UPB a;
        INT b pos := LWB b; INT b max = UPB b;
        WHILE
            IF a pos > a max OR b pos > b max THEN FALSE
            ELSE a[ a pos ] = b[ b pos ]
            FI
        DO
            a pos +:= 1; b pos +:= 1
        OD;
        a[ LWB a : a pos - 1 ]
    END # COMMONPREFIX # ;

# get the length of a string #
OP  LEN = ( STRING a )INT: ( UPB a + 1 ) - LWB a;

# find the longest common prefix of an array of STRINGs #
OP  LONGESTPREFIX = ( []STRING list )STRING:
    IF  UPB list < LWB list
    THEN
        # no elements #
        ""
    ELIF UPB list = LWB list
    THEN
        # only one element #
        list[ LWB list ]
    ELSE
        # more than one element #
        STRING prefix := list[ LWB list ] COMMONPREFIX list[ 1 + LWB list ];
        FOR pos FROM 2 + LWB list TO UPB list DO
            STRING next prefix := list[ pos ] COMMONPREFIX prefix;
            IF LEN next prefix < LEN prefix
            THEN
                # this element has a smaller common prefix #
                prefix := next prefix
            FI
        OD;
        prefix
    FI ;


# test the LONGESTPREFIX operator #

PROC test prefix = ( []STRING list, STRING expected result )VOID:
    BEGIN
        STRING prefix = LONGESTPREFIX list;
        print( ( "longest common prefix of (" ) );
        FOR pos FROM LWB list TO UPB list DO print( ( " """, list[ pos ], """" ) ) OD;
        print( ( " ) is: """, prefix, """ "
               , IF prefix = expected result THEN "as expected" ELSE "NOT AS EXPECTED" FI
               , newline
               )
             )
    END # test prefix # ;

[ 1 : 0 ]STRING empty list; # for recent versions of Algol 68G, can't just put "()" for an empty list #

BEGIN
    test prefix( ( "interspecies", "interstellar", "interstate" ), "inters" );
    test prefix( ( "throne", "throne" ), "throne" );
    test prefix( ( "throne", "dungeon" ), "" );
    test prefix( ( "throne", "", "throne" ), "" );
    test prefix( ( "cheese" ), "cheese" );
    test prefix( ( "" ), "" );
    test prefix( empty list, "" );
    test prefix( ( "prefix", "suffix" ), "" );
    test prefix( ( "foo", "foobar" ), "foo" )
END
