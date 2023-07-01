MODULE BoxTheCompass;
FROM FormatString IMPORT FormatString;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,Write,ReadChar;

PROCEDURE expand(cp : ARRAY OF CHAR);
VAR i : INTEGER = 0;
BEGIN
    WHILE cp[i] # 0C DO
        IF i=0 THEN
            CASE cp[i] OF
                'N': WriteString("North") |
                'E': WriteString("East")  |
                'S': WriteString("South") |
                'W': WriteString("West")  |
                'b': WriteString(" by ")
            ELSE
                WriteString("-");
            END;
        ELSE
            CASE cp[i] OF
                'N': WriteString("north") |
                'E': WriteString("east")  |
                'S': WriteString("south") |
                'W': WriteString("west")  |
                'b': WriteString(" by ")
            ELSE
                WriteString("-");
            END;
        END;
        INC(i)
    END;
END expand;

PROCEDURE FormatReal(r : REAL);
VAR
    buf : ARRAY[0..63] OF CHAR;
    u,v : INTEGER;
    w : REAL;
BEGIN
    u := TRUNC(r);
    w := r - FLOAT(u);
    v := TRUNC(100.0 * w);

    FormatString("%6i.%'02i", buf, u, v);
    WriteString(buf);
END FormatReal;

VAR
    cp : ARRAY[0..31] OF ARRAY[0..4] OF CHAR = {
        "N", "NbE", "N-NE", "NEbN", "NE", "NEbE", "E-NE", "EbN",
        "E", "EbS", "E-SE", "SEbE", "SE", "SEbS", "S-SE", "SbE",
        "S", "SbW", "S-SW", "SWbS", "SW", "SWbW", "W-SW", "WbS",
        "W", "WbN", "W-NW", "NWbW", "NW", "NWbN", "N-NW", "NbW"
    };
    buf : ARRAY[0..63] OF CHAR;
    i,index : INTEGER;
    heading : REAL;
BEGIN
    WriteString("Index  Degrees  Compass point");
    WriteLn;
    WriteString("-----  -------  -------------");
    WriteLn;
    FOR i:=0 TO 32 DO
        index := i MOD 32;
        heading := FLOAT(i) * 11.25;
        CASE i MOD 3 OF
            1: heading := heading + 5.62; |
            2: heading := heading - 5.62;
        ELSE
            (* empty *)
        END;
        FormatString("%2i  ", buf, index+1);
        WriteString(buf);
        FormatReal(heading);
        WriteString("   ");
        expand(cp[index]);
        WriteLn
    END;

    ReadChar
END BoxTheCompass.
