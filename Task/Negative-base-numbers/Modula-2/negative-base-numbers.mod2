MODULE NegativeBase;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

CONST DIGITS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
TYPE String = ARRAY[0..63] OF CHAR;

PROCEDURE EncodeNegativeBase(n : LONGINT; base : LONGINT) : String;
    PROCEDURE Mod(a,b : LONGINT) : LONGINT;
    BEGIN
        RETURN a - (a / b) * b
    END Mod;

    PROCEDURE Swap(VAR a,b : CHAR);
    VAR t : CHAR;
    BEGIN
        t := a;
        a := b;
        b := t
    END Swap;
VAR
    ptr,idx : CARDINAL;
    rem : LONGINT;
    result : String;
BEGIN
    IF (base > -1) OR (base < -62) THEN
        RETURN result
    ELSIF n = 0 THEN
        result := "0"
    ELSE
        ptr := 0;
        WHILE n # 0 DO
            rem := Mod(n, base);
            n := n / base;
            IF rem < 0 THEN
                INC(n);
                rem := rem - base
            END;
            result[ptr] := DIGITS[rem];
            INC(ptr);
        END
    END;
    result[ptr] := 0C;

    idx := 0;
    DEC(ptr);
    WHILE idx < ptr DO
        Swap(result[idx], result[ptr]);
        INC(idx);
        DEC(ptr)
    END;

    RETURN result
END EncodeNegativeBase;

PROCEDURE DecodeNegativeBase(ns : String; base : LONGINT) : LONGINT;
VAR
    total,bb,i,j : LONGINT;
BEGIN
    IF (base < -62) OR (base > -1) THEN
        RETURN 0
    ELSIF (ns[0] = 0C) OR ((ns[0] = '0') AND (ns[1] = 0C)) THEN
        RETURN 0
    ELSE
        FOR i:=0 TO HIGH(ns) DO
            IF ns[i] = 0C THEN
                BREAK
            END
        END;
        DEC(i);

        total := 0;
        bb := 1;
        WHILE i >= 0 DO
            FOR j:=0 TO HIGH(DIGITS) DO
                IF ns[i] = DIGITS[j] THEN
                    total := total + j * bb;
                    bb := bb * base;
                    BREAK
                END
            END;
            DEC(i)
        END;
    END;
    RETURN total
END DecodeNegativeBase;

PROCEDURE Driver(n,b : LONGINT);
VAR
    ns,buf : String;
    p : LONGINT;
BEGIN
    ns := EncodeNegativeBase(n, b);
    FormatString("%12l encoded in base %3l = %12s\n", buf, n, b, ns);
    WriteString(buf);

    p := DecodeNegativeBase(ns, b);
    FormatString("%12s decoded in base %3l = %12l\n", buf, ns, b, p);
    WriteString(buf);

    WriteLn
END Driver;

BEGIN
    Driver(10, -2);
    Driver(146, -3);
    Driver(15, -10);
    Driver(-19425187910, -62);

    ReadChar
END NegativeBase.
