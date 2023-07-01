MODULE Leonardo;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE leonardo(a,b,step,num : INTEGER);
VAR
    buf : ARRAY[0..63] OF CHAR;
    i,temp : INTEGER;
BEGIN
    FOR i:=1 TO num DO
        IF i=1 THEN
            FormatString(" %i", buf, a);
            WriteString(buf)
        ELSIF i=2 THEN
            FormatString(" %i", buf, b);
            WriteString(buf)
        ELSE
            FormatString(" %i", buf, a+b+step);
            WriteString(buf);

            temp := a;
            a := b;
            b := temp + b + step
        END
    END;
    WriteLn
END leonardo;

BEGIN
    leonardo(1,1,1,25);
    leonardo(0,1,0,25);

    ReadChar
END Leonardo.
