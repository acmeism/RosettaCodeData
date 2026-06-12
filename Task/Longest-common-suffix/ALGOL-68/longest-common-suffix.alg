# find the longest common suffix of two strings #
PRIO COMMONSUFFIX = 1;
OP   COMMONSUFFIX = ( STRING a, b )STRING:
    BEGIN
        INT a pos := UPB a; INT a min = LWB a;
        INT b pos := UPB b; INT b min = LWB b;
        WHILE
            IF a pos < a min OR b pos < b min THEN FALSE
            ELSE a[ a pos ] = b[ b pos ]
            FI
        DO
            a pos -:= 1; b pos -:= 1
        OD;
        a[ a pos + 1 : UPB a ]
    END # COMMONSUFFIX # ;
# get the length of a string #
OP  LEN = ( STRING a )INT: ( UPB a + 1 ) - LWB a;
# find the longest common suffix of an array of STRINGs #
OP  LONGESTSUFFIX = ( []STRING list )STRING:
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
        STRING suffix := list[ LWB list ] COMMONSUFFIX list[ 1 + LWB list ];
        FOR pos FROM 2 + LWB list TO UPB list WHILE suffix /= "" DO
            STRING next suffix := list[ pos ] COMMONSUFFIX suffix;
            IF LEN next suffix < LEN suffix
            THEN
                # this element has a smaller common suffix #
                suffix := next suffix
            FI
        OD;
        suffix
    FI ;
# test the LONGESTSUFFIX operator #
PROC test suffix = ( []STRING list, STRING expected result )VOID:
    BEGIN
        STRING suffix = LONGESTSUFFIX list;
        print( ( "longest common suffix of (" ) );
        FOR pos FROM LWB list TO UPB list DO print( ( " """, list[ pos ], """" ) ) OD;
        print( ( " ) is: """, suffix, """ "
               , IF suffix = expected result THEN "as expected" ELSE "NOT AS EXPECTED" FI
               , newline
               )
             )
    END # test suffix # ;
[ 1 : 0 ]STRING empty list; # for recent versions of Algol 68G, can't just put "()" for an empty list #
BEGIN
    test suffix( ( "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ), "day" );
    test suffix( ( "throne", "throne" ), "throne" );
    test suffix( ( "throne", "dungeon" ), "" );
    test suffix( ( "throne", "", "throne" ), "" );
    test suffix( ( "cheese" ), "cheese" );
    test suffix( ( "" ), "" );
    test suffix( empty list, "" );
    test suffix( ( "prefix", "suffix" ), "fix" );
    test suffix( ( "send", "lend" ), "end" )
END
