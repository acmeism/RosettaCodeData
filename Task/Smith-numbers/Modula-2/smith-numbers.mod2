MODULE SmithNumbers;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE SumDigits(n : INTEGER) : INTEGER;
VAR sum : INTEGER;
BEGIN
    sum := 0;
    WHILE n > 0 DO
        sum := sum + (n MOD 10);
        n := n DIV 10;
    END;
    RETURN sum;
END SumDigits;

VAR
    n,i,j,fc,sum,rc : INTEGER;
    buf : ARRAY[0..63] OF CHAR;
BEGIN
    rc := 0;
    FOR i:=1 TO 10000 DO
        n := i;
        fc := 0;
        sum := SumDigits(n);

        j := 2;
        WHILE n MOD j = 0 DO
            INC(fc);
            sum := sum - SumDigits(j);
            n := n DIV j;
        END;

        j := 3;
        WHILE j*j<=n DO
            WHILE n MOD j = 0 DO
                INC(fc);
                sum := sum - SumDigits(j);
                n := n DIV j;
            END;
            INC(j,2);
        END;

        IF n#1 THEN
            INC(fc);
            sum := sum - SumDigits(n);
        END;

        IF (fc>1) AND (sum=0) THEN
            FormatString("%4i  ", buf, i);
            WriteString(buf);
            INC(rc);
            IF rc=10 THEN
                rc := 0;
                WriteLn;
            END;
        END;
    END;

    ReadChar;
END SmithNumbers.
