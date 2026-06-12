MODULE SattoloCycle;
FROM FormatString IMPORT FormatString;
FROM RandomNumbers IMPORT Randomize,Random;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE SwapInt(VAR a,b : INTEGER);
VAR t : INTEGER;
BEGIN
    t := a;
    a := b;
    b := t;
END SwapInt;

TYPE
    ARR = ARRAY[0..5] OF INTEGER;
VAR
    buf : ARRAY[0..63] OF CHAR;
    items : ARR;
    i,j : INTEGER;
BEGIN
    Randomize(0);
    items := ARR{0,1,2,3,4,5};

    FOR i:=0 TO HIGH(items) DO
        j := Random(0,i);
        SwapInt(items[i], items[j]);
    END;

    FOR i:=0 TO HIGH(items) DO
        FormatString(" %i", buf, items[i]);
        WriteString(buf)
    END;

    ReadChar
END SattoloCycle.
