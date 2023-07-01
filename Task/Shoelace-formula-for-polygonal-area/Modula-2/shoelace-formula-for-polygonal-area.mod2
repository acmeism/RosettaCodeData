MODULE ShoelaceFormula;
FROM RealStr IMPORT RealToStr;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE
    Point = RECORD
        x,y : INTEGER;
    END;

PROCEDURE PointToString(self : Point; VAR buf : ARRAY OF CHAR);
BEGIN
    FormatString("(%i, %i)", buf, self.x, self.y);
END PointToString;

PROCEDURE ShoelaceArea(v : ARRAY OF Point) : REAL;
VAR
    a : REAL;
    i,n : INTEGER;
BEGIN
    n := HIGH(v);
    a := 0.0;
    FOR i:=0 TO n-1 DO
        a := a + FLOAT(v[i].x * v[i+1].y - v[i+1].x * v[i].y);
    END;
    RETURN ABS(a + FLOAT(v[n].x * v[0].y - v[0].x * v[n].y)) / 2.0;
END ShoelaceArea;

VAR
    v : ARRAY[0..4] OF Point;
    buf : ARRAY[0..63] OF CHAR;
    area : REAL;
    i : INTEGER;
BEGIN
    v[0] := Point{3,4};
    v[1] := Point{5,11};
    v[2] := Point{12,8};
    v[3] := Point{9,5};
    v[4] := Point{5,6};
    area := ShoelaceArea(v);

    WriteString("Given a polygon with verticies ");
    FOR i:=0 TO HIGH(v) DO
        PointToString(v[i], buf);
        WriteString(buf);
        WriteString(" ");
    END;
    WriteLn;

    RealToStr(area, buf);
    WriteString("its area is ");
    WriteString(buf);
    WriteLn;

    ReadChar;
END ShoelaceFormula.
