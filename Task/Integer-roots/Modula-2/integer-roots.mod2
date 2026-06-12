MODULE IntegerRoot;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

PROCEDURE pow(b : LONGCARD; p : CARDINAL) : LONGCARD;
VAR
    result : LONGCARD;
BEGIN
    result := 1;
    WHILE p > 0 DO
        IF p MOD 2 = 1 THEN
            DEC(p);
            result := result * b;
        END;
        p := p / 2;
        b := b * b
    END;
    RETURN result
END pow;

PROCEDURE root(base : LONGCARD; n : CARDINAL) : LONGCARD;
VAR
    n1,n2,n3,c,d,e : LONGCARD;
BEGIN
    IF base < 2 THEN RETURN base END;
    IF n = 0 THEN RETURN 1 END;

    n1 := n - 1;
    n2 := n;
    n3 := n1;
    c := 1;
    d := (n3 + base) / n2;
    e := (n3 * d + base / pow(d, n1)) / n2;

    WHILE (c # d) AND (c # e) DO
        c := d;
        d := e;
        e := (n3 * e + base / pow(e, n1)) / n2
    END;

    IF d < e THEN RETURN d END;
    RETURN e
END root;

(* main *)
VAR
    buf : ARRAY[0..63] OF CHAR;
    b : LONGCARD;
BEGIN
    FormatString("3rd root of 8 = %u\n", buf, root(8, 3));
    WriteString(buf);

    FormatString("3rd root of 9 = %u\n", buf, root(9, 3));
    WriteString(buf);

    b := 2000000000000000000;
    FormatString("2nd root of %u = %u\n", buf, b, root(b, 2));
    WriteString(buf);

    ReadChar
END IntegerRoot.
