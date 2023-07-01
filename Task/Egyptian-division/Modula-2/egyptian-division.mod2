MODULE EgyptianDivision;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

PROCEDURE EgyptianDivision(dividend,divisor : LONGCARD; VAR remainder : LONGCARD) : LONGCARD;
CONST
    SZ = 64;
VAR
    powers,doublings : ARRAY[0..SZ] OF LONGCARD;
    answer,accumulator : LONGCARD;
    i : INTEGER;
BEGIN
    FOR i:=0 TO SZ-1 DO
        powers[i] := 1 SHL i;
        doublings[i] := divisor SHL i;
        IF doublings[i] > dividend THEN
            BREAK
        END
    END;

    answer := 0;
    accumulator := 0;
    FOR i:=i-1 TO 0 BY -1 DO
        IF accumulator + doublings[i] <= dividend THEN
            accumulator := accumulator + doublings[i];
            answer := answer + powers[i]
        END
    END;

    remainder := dividend - accumulator;
    RETURN answer
END EgyptianDivision;

VAR
    buf : ARRAY[0..63] OF CHAR;
    div,rem : LONGCARD;
BEGIN
    div := EgyptianDivision(580, 34, rem);
    FormatString("580 divided by 34 is %l remainder %l\n", buf, div, rem);
    WriteString(buf);

    ReadChar
END EgyptianDivision.
