MODULE Emirp;
FROM Conversions IMPORT StrToLong;
FROM FormatString IMPORT FormatString;
FROM LongMath IMPORT sqrt;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE IsPrime(x : LONGINT) : BOOLEAN;
VAR
    i : LONGINT;
    u : LONGREAL;
    v : LONGINT;
BEGIN
    IF x<2 THEN RETURN FALSE END;
    IF x=2 THEN RETURN TRUE END;
    IF x MOD 2 = 0 THEN RETURN FALSE END;

    u := sqrt(FLOAT(x));
    v := TRUNC(u);

    FOR i:=3 TO v BY 2 DO
        IF x MOD i = 0 THEN RETURN FALSE END
    END;

    RETURN TRUE
END IsPrime;

PROCEDURE IsEmirp(x : LONGINT) : BOOLEAN;
VAR
    buf,rev : ARRAY[0..9] OF CHAR;
    i,j : INTEGER;
    y : LONGINT;
BEGIN
    (* Terminate early if the number is even *)
    IF x MOD 2 = 0 THEN RETURN FALSE END;

    (* First convert the input to a string *)
    FormatString("%l", buf, x);

    (* Create a copy of the string revered *)
    j := 0;
    WHILE buf[j] # 0C DO INC(j) END;
    DEC(j);
    i := 0;
    WHILE buf[i] # 0C DO
        rev[i] := buf[j];
        INC(i);
        DEC(j)
    END;
    rev[i] := 0C;

    (* Convert the reversed copy to a number *)
    StrToLong(rev,y);

    (* Terminate early if the number is even *)
    IF y MOD 2 = 0 THEN RETURN FALSE END;

    (* Discard palindromes *)
    IF x=y THEN RETURN FALSE END;

    RETURN IsPrime(x) AND IsPrime(y)
END IsEmirp;

VAR
    buf : ARRAY[0..63] OF CHAR;
    x,count : LONGINT;
BEGIN
    count := 0;
    x := 1;

    WriteString("First 20 emirps:");
    WriteLn;
    WHILE count<20 DO
        IF IsEmirp(x) THEN
            INC(count);
            FormatString("%l ", buf, x);
            WriteString(buf)
        END;
        INC(x)
    END;
    WriteLn;

    WriteString("Emirps between 7700 and 8000:");
    WriteLn;
    FOR x:=7700 TO 8000 DO
        IF IsEmirp(x) THEN
            FormatString("%l ", buf, x);
            WriteString(buf)
        END
    END;
    WriteLn;

    WriteString("10,000th emirp:");
    WriteLn;
    count := 0;
    x := 1;
    WHILE count<10000 DO
        IF IsEmirp(x) THEN
            INC(count);
        END;
        INC(x)
    END;
    FormatString("%l ", buf, x-1);
    WriteString(buf);
    WriteLn;

    ReadChar
END Emirp.
