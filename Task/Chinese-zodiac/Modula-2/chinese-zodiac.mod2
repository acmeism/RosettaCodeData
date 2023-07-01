MODULE ChineseZodiac;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

TYPE Str = ARRAY[0..7] OF CHAR;

TYPE AA = ARRAY[0..11] OF Str;
CONST ANIMALS = AA{"Rat","Ox","Tiger","Rabbit","Dragon","Snake","Horse","Goat","Monkey","Rooster","Dog","Pig"};

TYPE EA = ARRAY[0..4] OF Str;
CONST ELEMENTS = EA{"Wood","Fire","Earth","Metal","Water"};

PROCEDURE element(year : INTEGER) : Str;
VAR idx : CARDINAL;
BEGIN
    idx := ((year - 4) MOD 10) / 2;
    RETURN ELEMENTS[idx];
END element;

PROCEDURE animal(year : INTEGER) : Str;
VAR idx : CARDINAL;
BEGIN
    idx := (year - 4) MOD 12;
    RETURN ANIMALS[idx];
END animal;

PROCEDURE yy(year : INTEGER) : Str;
BEGIN
    IF year MOD 2 = 0 THEN
        RETURN "yang"
    ELSE
        RETURN "yin"
    END
END yy;

PROCEDURE print(year : INTEGER);
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    FormatString("%i is the year of the %s %s (%s)\n", buf, year, element(year), animal(year), yy(year));
    WriteString(buf);
END print;

(* main *)
BEGIN
    print(1935);
    print(1938);
    print(1968);
    print(1972);
    print(1976);
    print(2017);

    ReadChar
END ChineseZodiac.
