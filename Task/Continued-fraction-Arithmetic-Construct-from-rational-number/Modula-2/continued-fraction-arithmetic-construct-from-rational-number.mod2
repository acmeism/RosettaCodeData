MODULE ConstructFromrationalNumber;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE R2cf = RECORD
    num,den : INTEGER;
END;

PROCEDURE HasNext(self : R2cf) : BOOLEAN;
BEGIN
    RETURN self.den # 0;
END HasNext;

PROCEDURE Next(VAR self : R2cf) : INTEGER;
VAR div,rem : INTEGER;
BEGIN
    div := self.num / self.den;
    rem := self.num REM self.den;
    self.num := self.den;
    self.den := rem;
    RETURN div;
END Next;

PROCEDURE Iterate(self : R2cf);
VAR buf : ARRAY[0..64] OF CHAR;
BEGIN
    WHILE HasNext(self) DO
        FormatString("%i ", buf, Next(self));
        WriteString(buf);
    END;
    WriteLn;
END Iterate;

PROCEDURE Print(num,den : INTEGER);
VAR frac : R2cf;
VAR buf : ARRAY[0..64] OF CHAR;
BEGIN
    FormatString("%9i / %-9i = ", buf, num, den);
    WriteString(buf);

    frac.num := num;
    frac.den := den;
    Iterate(frac);
END Print;

VAR frac : R2cf;
BEGIN
    Print(1,2);
    Print(3,1);
    Print(23,8);
    Print(13,11);
    Print(22,7);
    Print(-151,77);

    WriteLn;
    WriteString("Sqrt(2) ->");
    WriteLn;
    Print(14142,10000);
    Print(141421,100000);
    Print(1414214,1000000);
    Print(14142136,10000000);

    WriteLn;
    WriteString("Pi ->");
    WriteLn;
    Print(31,10);
    Print(314,100);
    Print(3142,1000);
    Print(31428,10000);
    Print(314285,100000);
    Print(3142857,1000000);
    Print(31428571,10000000);
    Print(314285714,100000000);

    ReadChar;
END ConstructFromrationalNumber.
