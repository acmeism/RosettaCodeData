MODULE ConvexHull;
FROM FormatString IMPORT FormatString;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM SYSTEM IMPORT TSIZE;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteInt(n : INTEGER);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%i", buf, n);
    WriteString(buf);
END WriteInt;

TYPE
    Point = RECORD
        x, y : INTEGER;
    END;

PROCEDURE WritePoint(pt : Point);
BEGIN
    WriteString("(");
    WriteInt(pt.x);
    WriteString(", ");
    WriteInt(pt.y);
    WriteString(")");
END WritePoint;

TYPE
    NextNode = POINTER TO PNode;
    PNode = RECORD
        value : Point;
        next : NextNode;
    END;

PROCEDURE WriteNode(it : NextNode);
BEGIN
    IF it = NIL THEN
        RETURN
    END;
    WriteString("[");

    WritePoint(it^.value);
    it := it^.next;

    WHILE it # NIL DO
        WriteString(", ");
        WritePoint(it^.value);
        it := it^.next
    END;
    WriteString("]")
END WriteNode;

PROCEDURE AppendNode(pn : NextNode; p : Point) : NextNode;
VAR it,nx : NextNode;
BEGIN
    IF pn = NIL THEN
        ALLOCATE(it,TSIZE(PNode));
        it^.value := p;
        it^.next := NIL;
        RETURN it
    END;

    it := pn;
    WHILE it^.next # NIL DO
        it := it^.next
    END;

    ALLOCATE(nx,TSIZE(PNode));
    nx^.value := p;
    nx^.next := NIL;

    it^.next := nx;
    RETURN pn
END AppendNode;

PROCEDURE DeleteNode(VAR pn : NextNode);
BEGIN
    IF pn = NIL THEN RETURN END;
    DeleteNode(pn^.next);

    DEALLOCATE(pn,TSIZE(PNode));
    pn := NIL
END DeleteNode;

PROCEDURE SortNode(VAR pn : NextNode);
VAR
    it : NextNode;
    tmp : Point;
    done : BOOLEAN;
BEGIN
    REPEAT
        done := TRUE;
        it := pn;
        WHILE (it # NIL) AND (it^.next # NIL) DO
            IF it^.next^.value.x < it^.value.x THEN
                tmp := it^.value;
                it^.value := it^.next^.value;
                it^.next^.value := tmp;
                done := FALSE
            END;
            it := it^.next;
        END
    UNTIL done;
END SortNode;

PROCEDURE NodeLength(it : NextNode) : INTEGER;
VAR length : INTEGER;
BEGIN
    length := 0;
    WHILE it # NIL DO
        INC(length);
        it := it^.next;
    END;
    RETURN length
END NodeLength;

PROCEDURE ReverseNode(fp : NextNode) : NextNode;
VAR rp,tmp : NextNode;
BEGIN
    IF fp = NIL THEN RETURN NIL END;

    ALLOCATE(tmp,TSIZE(PNode));
    tmp^.value := fp^.value;
    tmp^.next := NIL;
    rp := tmp;
    fp := fp^.next;

    WHILE fp # NIL DO
        ALLOCATE(tmp,TSIZE(PNode));
        tmp^.value := fp^.value;
        tmp^.next := rp;
        rp := tmp;
        fp := fp^.next;
    END;

    RETURN rp
END ReverseNode;

(* ccw returns true if the three points make a counter-clockwise turn *)
PROCEDURE CCW(a,b,c : Point) : BOOLEAN;
BEGIN
    RETURN ((b.x - a.x) * (c.y - a.y)) > ((b.y - a.y) * (c.x - a.x))
END CCW;

PROCEDURE ConvexHull(p : NextNode) : NextNode;
VAR
    hull,it,h1,h2 : NextNode;
    t : INTEGER;
BEGIN
    IF p = NIL THEN RETURN NIL END;
    SortNode(p);
    hull := NIL;

    (* lower hull *)
    it := p;
    WHILE it # NIL DO
        IF hull # NIL THEN
            WHILE hull^.next # NIL DO
                (* At least two points in the list *)
                h2 := hull;
                h1 := hull^.next;
                WHILE h1^.next # NIL DO
                    h2 := h1;
                    h1 := h2^.next;
                END;

                IF CCW(h2^.value, h1^.value, it^.value) THEN
                    BREAK
                ELSE
                    h2^.next := NIL;
                    DeleteNode(h1);
                    h1 := NIL
                END
            END
        END;

        hull := AppendNode(hull, it^.value);
        it := it^.next;
    END;

    (* upper hull *)
    t := NodeLength(hull) + 1;
    p := ReverseNode(p);
    it := p;
    WHILE it # NIL DO
        WHILE NodeLength(hull) >= t DO
            h2 := hull;
            h1 := hull^.next;
            WHILE h1^.next # NIL DO
                h2 := h1;
                h1 := h2^.next;
            END;

            IF CCW(h2^.value, h1^.value, it^.value) THEN
                BREAK
            ELSE
                h2^.next := NIL;
                DeleteNode(h1);
                h1 := NIL
            END
        END;

        hull := AppendNode(hull, it^.value);
        it := it^.next;
    END;
    DeleteNode(p);

    h2 := hull;
    h1 := h2^.next;
    WHILE h1^.next # NIL DO
        h2 := h1;
        h1 := h1^.next;
    END;
    h2^.next := NIL;
    DeleteNode(h1);
    RETURN hull
END ConvexHull;

(* Main *)
VAR nodes,hull : NextNode;
BEGIN
    nodes := AppendNode(NIL, Point{16, 3});
    AppendNode(nodes, Point{12,17});
    AppendNode(nodes, Point{ 0, 6});
    AppendNode(nodes, Point{-4,-6});
    AppendNode(nodes, Point{16, 6});
    AppendNode(nodes, Point{16,-7});
    AppendNode(nodes, Point{16,-3});
    AppendNode(nodes, Point{17,-4});
    AppendNode(nodes, Point{ 5,19});
    AppendNode(nodes, Point{19,-8});
    AppendNode(nodes, Point{ 3,16});
    AppendNode(nodes, Point{12,13});
    AppendNode(nodes, Point{ 3,-4});
    AppendNode(nodes, Point{17, 5});
    AppendNode(nodes, Point{-3,15});
    AppendNode(nodes, Point{-3,-9});
    AppendNode(nodes, Point{ 0,11});
    AppendNode(nodes, Point{-9,-3});
    AppendNode(nodes, Point{-4,-2});
    AppendNode(nodes, Point{12,10});

    hull := ConvexHull(nodes);
    WriteNode(hull);
    DeleteNode(hull);

    DeleteNode(nodes);
    ReadChar
END ConvexHull.
