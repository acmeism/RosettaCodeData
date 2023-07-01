STRING lc := "";
STRING uc := "";
FOR c FROM 0 TO max abs char DO
    CHAR ch := REPR c;
    IF is lower( ch ) THEN lc +:= ch FI;
    IF is upper( ch ) THEN uc +:= ch FI
OD;
print( ( "lower: """ + lc + """", newline ) );
print( ( "upper: """ + uc + """", newline ) )
