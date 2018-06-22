MODULE CatalanNumbers;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE binomial(m,n : LONGCARD) : LONGCARD;
VAR r,d : LONGCARD;
BEGIN
    r := 1;
    d := m - n;
    IF d>n THEN
        n := d;
        d := m - n;
    END;
    WHILE m>n DO
        r := r * m;
        DEC(m);
        WHILE (d>1) AND NOT (r MOD d # 0) DO
            r := r DIV d;
            DEC(d)
        END
    END;
    RETURN r
END binomial;

PROCEDURE catalan1(n : LONGCARD) : LONGCARD;
BEGIN
    RETURN binomial(2*n,n) DIV (1+n)
END catalan1;

PROCEDURE catalan2(n : LONGCARD) : LONGCARD;
VAR i,sum : LONGCARD;
BEGIN
    IF n>1 THEN
        sum := 0;
        FOR i:=0 TO n-1 DO
            sum := sum + catalan2(i) * catalan2(n - 1 - i)
        END;
        RETURN sum
    ELSE
        RETURN 1
    END
END catalan2;

PROCEDURE catalan3(n : LONGCARD) : LONGCARD;
BEGIN
    IF n#0 THEN
        RETURN 2  *(2 * n - 1) * catalan3(n - 1) DIV (1 + n)
    ELSE
        RETURN 1
    END
END catalan3;

VAR
    blah : LONGCARD = 123;
    buf : ARRAY[0..63] OF CHAR;
    i : LONGCARD;
BEGIN
    FormatString("\tdirect\tsumming\tfrac\n", buf);
    WriteString(buf);
    FOR i:=0 TO 15 DO
        FormatString("%u\t%u\t%u\t%u\n", buf, i, catalan1(i), catalan2(i), catalan3(i));
        WriteString(buf)
    END;
    ReadChar
END CatalanNumbers.
