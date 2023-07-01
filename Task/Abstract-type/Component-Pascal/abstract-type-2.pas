(* Abstract method of Object *)
PROCEDURE (dn: Object) Show*, NEW, ABSTRACT;
	
(* Implementation of the abstract method Show() in class Integer *)
PROCEDURE (i: Integer) Show*;
BEGIN
	StdLog.String("Integer(");StdLog.Int(i.i);StdLog.String(");");StdLog.Ln
END Show;
	
(* Implementation of the abstract method Show() in class Point *)
PROCEDURE (p: Point) Show*;
BEGIN
	StdLog.String("Point(");StdLog.Real(p.x);StdLog.Char(',');
	StdLog.Real(p.y);StdLog.String(");");StdLog.Ln
END Show;
