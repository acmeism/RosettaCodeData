MODULE LeapYear;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

PROCEDURE IsLeapYear(year : INTEGER) : BOOLEAN;
BEGIN
    IF year MOD 100 = 0 THEN
        RETURN year MOD 400 = 0;
    END;
    RETURN year MOD 4 = 0
END IsLeapYear;

PROCEDURE Print(year : INTEGER);
VAR
    buf : ARRAY[0..63] OF CHAR;
    leap : BOOLEAN;
BEGIN
    leap := IsLeapYear(year);
    FormatString("Is %i a leap year? %b\n", buf, year, leap);
    WriteString(buf)
END Print;

BEGIN
    Print(1900);
    Print(1994);
    Print(1996);
    Print(1997);
    Print(2000);
    ReadChar
END LeapYear.
