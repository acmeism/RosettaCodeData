MODULE SortThreeVariables;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE SwapInt(VAR a,b : INTEGER);
VAR t : INTEGER;
BEGIN
    t := a;
    a := b;
    b := t;
END SwapInt;

PROCEDURE Sort3Int(VAR x,y,z : INTEGER);
BEGIN
    IF x<y THEN
        IF z<x THEN
            SwapInt(x,z);
        END;
    ELSIF y<z THEN
        SwapInt(x,y);
    ELSE
        SwapInt(x,z);
    END;
    IF z<y THEN
        SwapInt(y,z);
    END;
END Sort3Int;

VAR
    buf : ARRAY[0..63] OF CHAR;
    a,b,c : INTEGER;
BEGIN
    a := 77444;
    b := -12;
    c := 0;
    FormatString("Before a=[%i]; b=[%i]; c=[%i]\n", buf, a, b, c);
    WriteString(buf);

    Sort3Int(a,b,c);
    FormatString("Before a=[%i]; b=[%i]; c=[%i]\n", buf, a, b, c);
    WriteString(buf);

    ReadChar;
END SortThreeVariables.
