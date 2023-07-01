MODULE DepartmentNumbers;
FROM Conversions IMPORT IntToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(num : INTEGER);
VAR str : ARRAY[0..16] OF CHAR;
BEGIN
    IntToStr(num,str);
    WriteString(str);
END WriteInt;

VAR i,j,k,count : INTEGER;
BEGIN
    count:=0;

    WriteString("Police  Sanitation  Fire");
    WriteLn;
    WriteString("------  ----------  ----");
    WriteLn;

    FOR i:=2 TO 6 BY 2 DO
        FOR j:=1 TO 7 DO
            IF j=i THEN CONTINUE; END;
            FOR k:=1 TO 7 DO
                IF (k=i) OR (k=j) THEN CONTINUE; END;
                IF i+j+k # 12 THEN CONTINUE; END;
                WriteString("  ");
                WriteInt(i);
                WriteString("         ");
                WriteInt(j);
                WriteString("         ");
                WriteInt(k);
                WriteLn;
                INC(count);
            END;
        END;
    END;

    WriteLn;
    WriteInt(count);
    WriteString(" valid combinations");
    WriteLn;

    ReadChar;
END DepartmentNumbers.
