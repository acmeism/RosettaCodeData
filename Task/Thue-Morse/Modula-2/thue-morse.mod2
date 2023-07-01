MODULE ThueMorse;
FROM Strings IMPORT Concat;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE Sequence(steps : CARDINAL);
TYPE String = ARRAY[0..128] OF CHAR;
VAR sb1,sb2,tmp : String;
    i : CARDINAL;
BEGIN
    sb1 := "0";
    sb2 := "1";

    WHILE i<steps DO
        tmp := sb1;
        Concat(sb1, sb2, sb1);
        Concat(sb2, tmp, sb2);
        INC(i);
    END;
    WriteString(sb1);
    WriteLn;
END Sequence;

BEGIN
    Sequence(6);
    ReadChar;
END ThueMorse.
