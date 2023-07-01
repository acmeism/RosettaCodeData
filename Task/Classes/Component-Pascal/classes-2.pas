MODULE DrivePoint;
IMPORT
	Point,
	StdLog;
	
PROCEDURE Do*;
VAR
	p,q: Point.Instance;
BEGIN
	p := Point.New(1,2);
	q := Point.New(2,1);
	StdLog.String(p.ToString() + " + " + q.ToString() + " = " + p.Add(q).ToString());StdLog.Ln;
	StdLog.String("p.x:> ");StdLog.Int(p.x);StdLog.Ln;
	StdLog.String("p.y:> ");StdLog.Int(p.y);StdLog.Ln
END Do;

END DrivePoint.
