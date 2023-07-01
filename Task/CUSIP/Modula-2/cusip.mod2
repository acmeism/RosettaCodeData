MODULE CUSIP;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..10] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf)
END WriteInt;

PROCEDURE cusipCheckDigit(cusip : ARRAY OF CHAR) : INTEGER;
VAR
    i,v,sum : INTEGER;
BEGIN
    i := 0;
    sum := 0;
    WHILE cusip[i] # 0C DO
        IF ('0' <= cusip[i]) AND (cusip[i] <= '9') THEN
            v := ORD(cusip[i]) - 48 (* 0 *)
        ELSIF ('A' <= cusip[i]) AND (cusip[i] <= 'Z') THEN
            v := ORD(cusip[i]) - 65 (* A *) + 10
        ELSIF cusip[i] = '*' THEN
            v := 36
        ELSIF cusip[i] = '@' THEN
            v := 37
        ELSIF cusip[i] = '#' THEN
            v := 38
        ELSE
            RETURN -1
        END;
        IF i MOD 2 = 1 THEN v := 2 * v END;
        IF i < 8 THEN
            sum := sum + (v DIV 10) + (v MOD 10);
        END;
        INC(i)
    END;

    IF i # 9 THEN RETURN -1 END;
    RETURN (10 - (sum MOD 10)) MOD 10
END cusipCheckDigit;

PROCEDURE isValidCusip(cusip : ARRAY OF CHAR) : BOOLEAN;
VAR
    check : INTEGER;
BEGIN
    check := cusipCheckDigit(cusip);
    IF check < 0 THEN RETURN FALSE END;
    RETURN cusip[8] = CHR(48 (* 0 *) + check)
END isValidCusip;

PROCEDURE Print(cusip : ARRAY OF CHAR);
BEGIN
    WriteString(cusip);
    IF isValidCusip(cusip) THEN
        WriteString(" : Valid")
    ELSE
        WriteString(" : Invalid")
    END;
    WriteLn
END Print;

(* main *)
BEGIN
    WriteString("CUSIP       Verdict");
    WriteLn;

    Print("037833100");
    Print("17275R102");
    Print("38259P508");
    Print("594918104");
    Print("68389X106");
    Print("68389X105");

    ReadChar
END CUSIP.
