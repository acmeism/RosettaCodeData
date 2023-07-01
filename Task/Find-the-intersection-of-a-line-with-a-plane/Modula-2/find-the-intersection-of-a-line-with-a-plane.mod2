MODULE LinePlane;
FROM RealStr IMPORT RealToStr;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

TYPE
    Vector3D = RECORD
        x,y,z : REAL;
    END;

PROCEDURE Minus(lhs,rhs : Vector3D) : Vector3D;
VAR out : Vector3D;
BEGIN
    RETURN Vector3D{lhs.x-rhs.x, lhs.y-rhs.y, lhs.z-rhs.z};
END Minus;

PROCEDURE Times(a : Vector3D; s : REAL) : Vector3D;
BEGIN
    RETURN Vector3D{a.x*s, a.y*s, a.z*s};
END Times;

PROCEDURE Dot(lhs,rhs : Vector3D) : REAL;
BEGIN
    RETURN lhs.x*rhs.x + lhs.y*rhs.y + lhs.z*rhs.z;
END Dot;

PROCEDURE ToString(self : Vector3D);
VAR buf : ARRAY[0..63] OF CHAR;
BEGIN
    WriteString("(");
    RealToStr(self.x,buf);
    WriteString(buf);
    WriteString(", ");
    RealToStr(self.y,buf);
    WriteString(buf);
    WriteString(", ");
    RealToStr(self.z,buf);
    WriteString(buf);
    WriteString(")");
END ToString;

PROCEDURE IntersectPoint(rayVector,rayPoint,planeNormal,planePoint : Vector3D) : Vector3D;
VAR
    diff : Vector3D;
    prod1,prod2,prod3 : REAL;
BEGIN
    diff := Minus(rayPoint,planePoint);
    prod1 := Dot(diff, planeNormal);
    prod2 := Dot(rayVector, planeNormal);
    prod3 := prod1 / prod2;
    RETURN Minus(rayPoint, Times(rayVector, prod3));
END IntersectPoint;

VAR ip : Vector3D;
BEGIN
    ip := IntersectPoint(Vector3D{0.0,-1.0,-1.0},Vector3D{0.0,0.0,10.0},Vector3D{0.0,0.0,1.0},Vector3D{0.0,0.0,5.0});

    WriteString("The ray intersects the plane at ");
    ToString(ip);
    WriteLn;

    ReadChar;
END LinePlane.
