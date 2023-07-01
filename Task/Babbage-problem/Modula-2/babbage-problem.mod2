MODULE BabbageProblem;
FROM FormatString IMPORT FormatString;
FROM RealMath IMPORT sqrt;
FROM Terminal IMPORT WriteString,ReadChar;

VAR
    buf : ARRAY[0..63] OF CHAR;
    k : INTEGER;
BEGIN
    (* Find the greatest integer less than the square root *)
    k := TRUNC(sqrt(269696.0));

    (* Odd numbers cannot be solutions, so decrement *)
    IF k MOD 2 = 1 THEN
        DEC(k);
    END;

    (* Find a number that meets the criteria *)
    WHILE (k*k) MOD 1000000 # 269696 DO
        INC(k,2)
    END;

    FormatString("%i * %i = %i", buf, k, k, k*k);
    WriteString(buf);

    ReadChar
END BabbageProblem.
