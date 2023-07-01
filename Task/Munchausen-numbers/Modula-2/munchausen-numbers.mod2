MODULE MunchausenNumbers;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

(* Simple power function, does not handle negatives *)
PROCEDURE Pow(b,e : INTEGER) : INTEGER;
VAR result : INTEGER;
BEGIN
    IF e=0 THEN
        RETURN 1;
    END;
    IF b=0 THEN
        RETURN 0;
    END;

    result := b;
    DEC(e);
    WHILE e>0 DO
        result := result * b;
        DEC(e);
    END;
    RETURN result;
END Pow;

VAR
    buf : ARRAY[0..31] OF CHAR;
    i,sum,number,digit : INTEGER;
BEGIN
    FOR i:=1 TO 5000 DO
        (* Loop through each digit in i
           e.g. for 1000 we get 0, 0, 0, 1. *)
        sum := 0;
        number := i;
        WHILE number>0 DO
            digit := number MOD 10;
            sum := sum + Pow(digit, digit);
            number := number DIV 10;
        END;
        IF sum=i THEN
            FormatString("%i\n", buf, i);
            WriteString(buf);
        END;
    END;

    ReadChar;
END MunchausenNumbers.
