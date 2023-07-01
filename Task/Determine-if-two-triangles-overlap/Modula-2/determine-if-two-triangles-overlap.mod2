MODULE Overlap;
FROM EXCEPTIONS IMPORT AllocateSource,ExceptionSource,GetMessage,RAISE;
FROM LongStr IMPORT RealToFixed;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE
    Point = RECORD
        x,y : LONGREAL;
    END;
    Triangle = RECORD
        p1,p2,p3 : Point;
    END;

VAR
    TextWinExSrc : ExceptionSource;

PROCEDURE WritePoint(p : Point);
VAR buf : ARRAY[0..31] OF CHAR;
BEGIN
    WriteString("(");
    RealToFixed(p.x, 2, buf);
    WriteString(buf);
    WriteString(", ");
    RealToFixed(p.y, 2, buf);
    WriteString(buf);
    WriteString(")")
END WritePoint;

PROCEDURE WriteTriangle(t : Triangle);
BEGIN
    WriteString("Triangle: ");
    WritePoint(t.p1);
    WriteString(", ");
    WritePoint(t.p2);
    WriteString(", ");
    WritePoint(t.p3)
END WriteTriangle;

PROCEDURE Det2D(p1,p2,p3 : Point) : LONGREAL;
BEGIN
    RETURN p1.x * (p2.y - p3.y)
         + p2.x * (p3.y - p1.y)
         + p3.x * (p1.y - p2.y)
END Det2D;

PROCEDURE CheckTriWinding(VAR p1,p2,p3 : Point; allowReversed : BOOLEAN);
VAR
    detTri : LONGREAL;
    t : Point;
BEGIN
    detTri := Det2D(p1, p2, p3);
    IF detTri < 0.0 THEN
        IF allowReversed THEN
            t := p3;
            p3 := p2;
            p2 := t
        ELSE
            RAISE(TextWinExSrc, 0, "triangle has wrong winding direction")
        END
    END
END CheckTriWinding;

PROCEDURE BoundaryCollideChk(p1,p2,p3 : Point; eps : LONGREAL) : BOOLEAN;
BEGIN
    RETURN Det2D(p1, p2, p3) < eps
END BoundaryCollideChk;

PROCEDURE BoundaryDoesntCollideChk(p1,p2,p3 : Point; eps : LONGREAL) : BOOLEAN;
BEGIN
    RETURN Det2D(p1, p2, p3) <= eps
END BoundaryDoesntCollideChk;

PROCEDURE TriTri2D(t1,t2 : Triangle; eps : LONGREAL; allowReversed,onBoundary : BOOLEAN) : BOOLEAN;
TYPE
    Points = ARRAY[0..2] OF Point;
VAR
    chkEdge : PROCEDURE(Point, Point, Point, LONGREAL) : BOOLEAN;
    lp1,lp2 : Points;
    i,j : CARDINAL;
BEGIN
    (* Triangles must be expressed anti-clockwise *)
    CheckTriWinding(t1.p1, t1.p2, t1.p3, allowReversed);
    CheckTriWinding(t2.p1, t2.p2, t2.p3, allowReversed);

    (* 'onBoundary' determines whether points on boundary are considered as colliding or not *)
    IF onBoundary THEN
        chkEdge := BoundaryCollideChk
    ELSE
        chkEdge := BoundaryDoesntCollideChk
    END;

    lp1 := Points{t1.p1, t1.p2, t1.p3};
    lp2 := Points{t2.p1, t2.p2, t2.p3};

    (* for each edge E of t1 *)
    FOR i:=0 TO 2 DO
        j := (i + 1) MOD 3;
        (* Check all points of t2 lay on the external side of edge E.
           If they do, the triangles do not overlap. *)
        IF     chkEdge(lp1[i], lp1[j], lp2[0], eps)
           AND chkEdge(lp1[i], lp1[j], lp2[1], eps)
           AND chkEdge(lp1[i], lp1[j], lp2[2], eps)
        THEN
            RETURN FALSE
        END
    END;

    (* for each edge E of t2 *)
    FOR i:=0 TO 2 DO
        j := (i + 1) MOD 3;
        (* Check all points of t1 lay on the external side of edge E.
           If they do, the triangles do not overlap. *)
        IF     chkEdge(lp2[i], lp2[j], lp1[0], eps)
           AND chkEdge(lp2[i], lp2[j], lp1[1], eps)
           AND chkEdge(lp2[i], lp2[j], lp1[2], eps)
        THEN
            RETURN FALSE
        END
    END;

    (* The triangles overlap *)
    RETURN TRUE
END TriTri2D;

PROCEDURE CheckOverlap(t1,t2 : Triangle; eps : LONGREAL; allowReversed,onBoundary : BOOLEAN);
BEGIN
    WriteTriangle(t1);
    WriteString(" and");
    WriteLn;
    WriteTriangle(t2);
    WriteLn;

    IF TriTri2D(t1, t2, eps, allowReversed, onBoundary) THEN
        WriteString("overlap")
    ELSE
        WriteString("do not overlap")
    END;
    WriteLn
END CheckOverlap;

(* main *)
VAR
    t1,t2 : Triangle;
BEGIN
    t1 := Triangle{{0.0,0.0},{5.0,0.0},{0.0,5.0}};
    t2 := Triangle{{0.0,0.0},{5.0,0.0},{0.0,6.0}};
    CheckOverlap(t1, t2, 0.0, FALSE, TRUE);
    WriteLn;

    t1 := Triangle{{0.0,0.0},{0.0,5.0},{5.0,0.0}};
    t2 := Triangle{{0.0,0.0},{0.0,5.0},{5.0,0.0}};
    CheckOverlap(t1, t2, 0.0, TRUE, TRUE);
    WriteLn;

    t1 := Triangle{{0.0,0.0},{5.0,0.0},{0.0,5.0}};
    t2 := Triangle{{-10.0,0.0},{-5.0,0.0},{-1.0,6.0}};
    CheckOverlap(t1, t2, 0.0, FALSE, TRUE);
    WriteLn;

    t1 := Triangle{{0.0,0.0},{5.0,0.0},{2.5,5.0}};
    t2 := Triangle{{0.0,4.0},{2.5,-1.0},{5.0,4.0}};
    CheckOverlap(t1, t2, 0.0, FALSE, TRUE);
    WriteLn;

    t1 := Triangle{{0.0,0.0},{1.0,1.0},{0.0,2.0}};
    t2 := Triangle{{2.0,1.0},{3.0,0.0},{3.0,2.0}};
    CheckOverlap(t1, t2, 0.0, FALSE, TRUE);
    WriteLn;

    t1 := Triangle{{0.0,0.0},{1.0,1.0},{0.0,2.0}};
    t2 := Triangle{{2.0,1.0},{3.0,-2.0},{3.0,4.0}};
    CheckOverlap(t1, t2, 0.0, FALSE, TRUE);
    WriteLn;

    t1 := Triangle{{0.0,0.0},{1.0,0.0},{0.0,1.0}};
    t2 := Triangle{{1.0,0.0},{2.0,0.0},{1.0,1.1}};
    CheckOverlap(t1, t2, 0.0, FALSE, TRUE);
    WriteLn;

    t1 := Triangle{{0.0,0.0},{1.0,0.0},{0.0,1.0}};
    t2 := Triangle{{1.0,0.0},{2.0,0.0},{1.0,1.1}};
    CheckOverlap(t1, t2, 0.0, FALSE, FALSE);
    WriteLn;

    ReadChar
END Overlap.
