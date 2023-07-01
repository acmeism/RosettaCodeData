MODULE FourSquare;
FROM Conversions IMPORT IntToStr;
FROM Terminal IMPORT *;

PROCEDURE WriteInt(num : INTEGER);
VAR str : ARRAY[0..16] OF CHAR;
BEGIN
    IntToStr(num,str);
    WriteString(str);
END WriteInt;

PROCEDURE four_square(low, high : INTEGER; unique, print : BOOLEAN);
VAR count : INTEGER;
VAR a, b, c, d, e, f, g : INTEGER;
VAR fp : INTEGER;
BEGIN
    count:=0;

    IF print THEN
        WriteString('a b c d e f g');
        WriteLn;
    END;
    FOR a:=low TO high DO
        FOR b:=low TO high DO
            IF unique AND (b=a) THEN CONTINUE; END;

            fp:=a+b;
            FOR c:=low TO high DO
                IF unique AND ((c=a) OR (c=b)) THEN CONTINUE; END;
                FOR d:=low TO high DO
                    IF unique AND ((d=a) OR (d=b) OR (d=c)) THEN CONTINUE; END;
                    IF fp # b+c+d THEN CONTINUE; END;

                    FOR e:=low TO high DO
                        IF unique AND ((e=a) OR (e=b) OR (e=c) OR (e=d)) THEN CONTINUE; END;
                        FOR f:=low TO high DO
                            IF unique AND ((f=a) OR (f=b) OR (f=c) OR (f=d) OR (f=e)) THEN CONTINUE; END;
                            IF fp # d+e+f THEN CONTINUE; END;

                            FOR g:=low TO high DO
                                IF unique AND ((g=a) OR (g=b) OR (g=c) OR (g=d) OR (g=e) OR (g=f)) THEN CONTINUE; END;
                                IF fp # f+g THEN CONTINUE; END;

                                INC(count);
                                IF print THEN
                                    WriteInt(a);
                                    WriteString(' ');
                                    WriteInt(b);
                                    WriteString(' ');
                                    WriteInt(c);
                                    WriteString(' ');
                                    WriteInt(d);
                                    WriteString(' ');
                                    WriteInt(e);
                                    WriteString(' ');
                                    WriteInt(f);
                                    WriteString(' ');
                                    WriteInt(g);
                                    WriteLn;
                                END;
                            END;
                        END;
                    END;
                END;
            END;
        END;
    END;
    IF unique THEN
        WriteString('There are ');
        WriteInt(count);
        WriteString(' unique solutions in [');
        WriteInt(low);
        WriteString(', ');
        WriteInt(high);
        WriteString(']');
        WriteLn;
    ELSE
        WriteString('There are ');
        WriteInt(count);
        WriteString(' non-unique solutions in [');
        WriteInt(low);
        WriteString(', ');
        WriteInt(high);
        WriteString(']');
        WriteLn;
    END;
END four_square;

BEGIN
    four_square(1,7,TRUE,TRUE);
    four_square(3,9,TRUE,TRUE);
    four_square(0,9,FALSE,FALSE);
    ReadChar; (* Wait so results can be viewed. *)
END FourSquare.
