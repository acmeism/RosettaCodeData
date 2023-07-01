MODULE Cantor;
FROM Terminal IMPORT Write,WriteLn,ReadChar;

CONST
    WIDTH = 81;
    HEIGHT = 5;
VAR
    lines : ARRAY[0..HEIGHT] OF ARRAY[0..WIDTH] OF CHAR;

PROCEDURE Init;
VAR i,j : CARDINAL;
BEGIN
    FOR i:=0 TO HEIGHT DO
        FOR j:=0 TO WIDTH DO
            lines[i,j] := '*'
        END
    END
END Init;

PROCEDURE Cantor(start,len,index : CARDINAL);
VAR i,j,seg : CARDINAL;
BEGIN
    seg := len DIV 3;
    IF seg=0 THEN RETURN END;
    FOR i:=index TO HEIGHT-1 DO
        j := start+seg;
        FOR j:=start+seg TO start+seg*2-1 DO
            lines[i,j] := ' '
        END
    END;
    Cantor(start, seg, index+1);
    Cantor(start+seg*2, seg, index+1)
END Cantor;

PROCEDURE Print;
VAR i,j : CARDINAL;
BEGIN
    FOR i:=0 TO HEIGHT-1 DO
        FOR j:=0 TO WIDTH-1 DO
            Write(lines[i,j])
        END;
        WriteLn
    END
END Print;

BEGIN
    Init;
    Cantor(0,WIDTH,1);
    Print;

    ReadChar;
END Cantor.
