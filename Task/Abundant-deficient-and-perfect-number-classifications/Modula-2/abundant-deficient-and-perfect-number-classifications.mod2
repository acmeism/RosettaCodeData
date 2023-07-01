MODULE ADP;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE ProperDivisorSum(n : INTEGER) : INTEGER;
VAR i,sum : INTEGER;
BEGIN
    sum := 0;
    IF n<2 THEN
        RETURN 0
    END;
    FOR i:=1 TO (n DIV 2) DO
        IF n MOD i = 0 THEN
            INC(sum,i)
        END
    END;
    RETURN sum
END ProperDivisorSum;

VAR
    buf : ARRAY[0..63] OF CHAR;
    n : INTEGER;
    d,p,a : INTEGER = 0;
    sum : INTEGER;
BEGIN
    FOR n:=1 TO 20000 DO
        sum := ProperDivisorSum(n);
        IF sum<n THEN
            INC(d)
        ELSIF sum=n THEN
            INC(p)
        ELSIF sum>n THEN
            INC(a)
        END
    END;

    WriteString("The classification of the numbers from 1 to 20,000 is as follows:");
    WriteLn;

    FormatString("Deficient = %i\n", buf, d);
    WriteString(buf);
    FormatString("Perfect = %i\n", buf, p);
    WriteString(buf);
    FormatString("Abundant = %i\n", buf, a);
    WriteString(buf);
    ReadChar
END ADP.
