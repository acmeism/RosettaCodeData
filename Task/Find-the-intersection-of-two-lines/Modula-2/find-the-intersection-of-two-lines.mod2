MODULE LineIntersection;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE
    Point = RECORD
        x,y : REAL;
    END;

PROCEDURE PrintPoint(p : Point);
VAR buf : ARRAY[0..31] OF CHAR;
BEGIN
    WriteString("{");
    RealToStr(p.x, buf);
    WriteString(buf);
    WriteString(", ");
    RealToStr(p.y, buf);
    WriteString(buf);
    WriteString("}");
END PrintPoint;

TYPE
    Line = RECORD
        s,e : Point;
    END;

PROCEDURE FindIntersection(l1,l2 : Line) : Point;
VAR a1,b1,c1,a2,b2,c2,delta : REAL;
BEGIN
    a1 := l1.e.y - l1.s.y;
    b1 := l1.s.x - l1.e.x;
    c1 := a1 * l1.s.x + b1 * l1.s.y;

    a2 := l2.e.y - l2.s.y;
    b2 := l2.s.x - l2.e.x;
    c2 := a2 * l2.s.x + b2 * l2.s.y;

    delta := a1 * b2 - a2 * b1;
    RETURN Point{(b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta};
END FindIntersection;

VAR
    l1,l2 : Line;
    result : Point;
BEGIN
    l1 := Line{{4.0,0.0}, {6.0,10.0}};
    l2 := Line{{0.0,3.0}, {10.0,7.0}};
    PrintPoint(FindIntersection(l1,l2));
    WriteLn;

    l1 := Line{{0.0,0.0}, {1.0,1.0}};
    l2 := Line{{1.0,2.0}, {4.0,5.0}};
    PrintPoint(FindIntersection(l1,l2));
    WriteLn;

    ReadChar;
END LineIntersection.
