MODULE Kaprekar;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT Write,WriteString,WriteLn,ReadChar;

PROCEDURE kaprekar(n,base : LONGCARD) : BOOLEAN;
VAR
    nn,r,tens : LONGCARD;
BEGIN
    nn := n*n;
    tens := 1;
    IF ((nn - n) MOD (base - 1)) # 0 THEN RETURN FALSE END;

    WHILE tens < n DO tens := tens * base END;
    IF n = tens THEN
        IF 1 = n THEN RETURN TRUE END;
        RETURN FALSE
    END;

    LOOP
        r := nn MOD tens;
        IF r >= n THEN BREAK END;
        IF nn DIV tens + r = n THEN RETURN tens#0 END;
        tens := tens * base;
    END;

    RETURN FALSE
END kaprekar;

PROCEDURE print_num(n,base : LONGCARD);
VAR q,d : LONGCARD;
BEGIN
    d := base;

    WHILE d<n DO d := d * base END;
    LOOP
        d := d DIV base;
        IF n BAND d = 0 THEN RETURN END;
        q := n DIV d;
        IF q<10 THEN
            Write(CHR(INT(q) + INT(ORD('0'))))
        ELSE
            Write(CHR(INT(q) + INT(ORD('a')) - 10))
        END;
        n := n - q * d
    END
END print_num;

VAR
    buf : ARRAY[0..63] OF CHAR;
    i,tens,cnt,base : LONGCARD;
BEGIN
    cnt := 0;
    base := 10;
    FOR i:=1 TO 1000000 DO
        IF kaprekar(i,base) THEN
            INC(cnt);
            FormatString("%3u: %u\n", buf, cnt, i);
            WriteString(buf)
        END
    END;

    ReadChar
END Kaprekar.
