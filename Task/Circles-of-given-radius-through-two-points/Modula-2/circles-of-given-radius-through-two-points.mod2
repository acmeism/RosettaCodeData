MODULE Circles;
FROM EXCEPTIONS IMPORT AllocateSource,ExceptionSource,GetMessage,RAISE;
FROM FormatString IMPORT FormatString;
FROM LongMath IMPORT sqrt;
FROM LongStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

VAR
    TextWinExSrc : ExceptionSource;

TYPE
    Point = RECORD
        x,y : LONGREAL;
    END;
    Pair = RECORD
        a,b : Point;
    END;

PROCEDURE Distance(p1,p2 : Point) : LONGREAL;
VAR dx,dy : LONGREAL;
BEGIN
    dx := p1.x - p2.x;
    dy := p1.y - p2.y;
    RETURN sqrt(dx*dx + dy*dy)
END Distance;

PROCEDURE Equal(p1,p2 : Point) : BOOLEAN;
BEGIN
    RETURN (p1.x=p2.x) AND (p1.y=p2.y)
END Equal;

PROCEDURE WritePoint(p : Point);
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    WriteString("(");
    RealToStr(p.x, buf);
    WriteString(buf);
    WriteString(", ");
    RealToStr(p.y, buf);
    WriteString(buf);
    WriteString(")");
END WritePoint;

PROCEDURE FindCircles(p1,p2 : Point; r : LONGREAL) : Pair;
VAR
    distance,diameter,mirrorDistance,dx,dy : LONGREAL;
    center : Point;
BEGIN
    IF r < 0.0 THEN RAISE(TextWinExSrc, 0, "the radius can't be negative") END;
    IF (r = 0.0) AND NOT Equal(p1,p2) THEN RAISE(TextWinExSrc, 0, "No circles can ever be drawn") END;
    IF r = 0.0 THEN RETURN Pair{p1,p1} END;
    IF Equal(p1,p2) THEN RAISE(TextWinExSrc, 0, "an infinite number of circles can be drawn") END;
    distance := Distance(p1,p2);
    diameter := 2.0 * r;
    IF distance > diameter THEN RAISE(TextWinExSrc, 0, "the points are too far apart to draw a circle") END;
    center := Point{(p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0};
    IF distance = diameter THEN RETURN Pair{center, center} END;
    mirrorDistance := sqrt(r * r - distance * distance / 4.0);
    dx := (p2.x - p1.x) * mirrorDistance / distance;
    dy := (p2.y - p1.y) * mirrorDistance / distance;
    RETURN Pair{
        {center.x - dy, center.y + dx},
        {center.x + dy, center.y - dx}
    }
END FindCircles;

PROCEDURE Print(p1,p2 : Point; r : LONGREAL) : BOOLEAN;
VAR
    buf : ARRAY[0..63] OF CHAR;
    result : Pair;
BEGIN
    WriteString("For points ");
    WritePoint(p1);
    WriteString(" and ");
    WritePoint(p2);
    WriteString(" with radius ");
    RealToStr(r, buf);
    WriteString(buf);
    WriteLn;

    result := FindCircles(p1,p2,r);
    IF Equal(result.a, result.b) THEN
        WriteString("there is just one circle with the center at ");
        WritePoint(result.a);
        WriteLn;
    ELSE
        WriteString("there are two circles with centers at ");
        WritePoint(result.a);
        WriteString(" and ");
        WritePoint(result.b);
        WriteLn;
    END;
    WriteLn;
    RETURN TRUE
EXCEPT
    GetMessage(buf);
    WriteString(buf);
    WriteLn;
    WriteLn;
    RETURN FALSE
END Print;

VAR p0,p1,p2,p3 : Point;
BEGIN
    AllocateSource(TextWinExSrc);
    p0 := Point{0.1234,0.9876};
    p1 := Point{0.8765,0.2345};
    p2 := Point{0.0000,2.0000};
    p3 := Point{0.0000,0.0000};

    Print(p0,p1,2.0);
    Print(p2,p3,1.0);
    Print(p0,p0,2.0);
    Print(p0,p1,0.5);
    Print(p0,p0,0.0);

    ReadChar
END Circles.
