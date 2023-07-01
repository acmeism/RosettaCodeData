# reverses the characters in str from start pos to end pos                   #
PROC in place reverse = ( REF STRING str, INT start pos, INT end pos )VOID:
    BEGIN
        INT fpos := start pos, epos := end pos;
        WHILE fpos < epos
        DO
            CHAR c      := str[ fpos ];
            str[ fpos ] := str[ epos ];
            str[ epos ] := c;
            fpos       +:= 1;
            epos       -:= 1
        OD
    END; # in place reverse #

STRING original phrase := "rosetta code phrase reversal";

STRING whole reversed  := original phrase;
in place reverse( whole reversed, LWB whole reversed, UPB whole reversed );

# reverse the individual words #
STRING words reversed := original phrase;
INT start pos         := LWB words reversed;

WHILE
    # skip leading spaces #
    WHILE IF start pos <= UPB words reversed
          THEN words reversed[ start pos ] = " "
          ELSE FALSE
          FI
    DO start pos +:= 1
    OD;
    start pos <= UPB words reversed
DO
    # have another word, find it #
    INT end pos := start pos;
    WHILE IF end pos <= UPB words reversed
          THEN words reversed[ end pos ] /= " "
          ELSE FALSE
          FI
    DO end pos +:= 1
    OD;
    in place reverse( words reversed, start pos, end pos - 1 );
    start pos := end pos + 1
OD;

# reversing the reversed words in the same order as the original will        #
# reverse the order of the words                                             #
STRING order reversed := words reversed;
in place reverse( order reversed, LWB order reversed, UPB order reversed );

print( ( original phrase, ": whole reversed -> ", whole reversed, newline
       , original phrase, ": words reversed -> ", words reversed, newline
       , original phrase, ": order reversed -> ", order reversed, newline
       )
 )
