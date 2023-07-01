MODULE DigitalRoot;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE Root =
    RECORD
        persistence,root : LONGINT;
    END;

PROCEDURE digitalRoot(inRoot,base : LONGINT) : Root;
VAR root,persistence,num : LONGINT;
BEGIN
    root := ABS(inRoot);
    persistence := 0;
    WHILE root>=base DO
        num := root;
        root := 0;
        WHILE num#0 DO
            root := root + (num MOD base);
            num := num DIV base;
        END;
        INC(persistence)
    END;
    RETURN Root{persistence, root}
END digitalRoot;

PROCEDURE Print(n,b : LONGINT);
VAR
    buf : ARRAY[0..63] OF CHAR;
    r : Root;
BEGIN
    r := digitalRoot(n,b);
    FormatString("%u (base %u): persistence=%u, digital root=%u\n", buf, n, b, r.persistence, r.root);
    WriteString(buf)
END Print;

VAR
    buf : ARRAY[0..63] OF CHAR;
    b,n : LONGINT;
    r : Root;
BEGIN
    Print(1,10);
    Print(14,10);
    Print(267,10);
    Print(8128,10);
    Print(39390,10);
    Print(627615,10);
    Print(588225,10);

    ReadChar
END DigitalRoot.
