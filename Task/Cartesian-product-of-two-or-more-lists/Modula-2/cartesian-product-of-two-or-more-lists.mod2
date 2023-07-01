MODULE CartesianProduct;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(a : INTEGER);
VAR buf : ARRAY[0..9] OF CHAR;
BEGIN
    FormatString("%i", buf, a);
    WriteString(buf)
END WriteInt;

PROCEDURE Cartesian(a,b : ARRAY OF INTEGER);
VAR i,j : CARDINAL;
BEGIN
    WriteString("[");
    FOR i:=0 TO HIGH(a) DO
        FOR j:=0 TO HIGH(b) DO
            IF (i>0) OR (j>0) THEN
                WriteString(",");
            END;
            WriteString("[");
            WriteInt(a[i]);
            WriteString(",");
            WriteInt(b[j]);
            WriteString("]")
        END
    END;
    WriteString("]");
    WriteLn
END Cartesian;

TYPE
    AP = ARRAY[0..1] OF INTEGER;
    E = ARRAY[0..0] OF INTEGER;
VAR
    a,b : AP;
BEGIN
    a := AP{1,2};
    b := AP{3,4};
    Cartesian(a,b);

    a := AP{3,4};
    b := AP{1,2};
    Cartesian(a,b);

    (* If there is a way to create an empty array, I do not know of it *)

    ReadChar
END CartesianProduct.
