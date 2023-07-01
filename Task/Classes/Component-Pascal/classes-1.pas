MODULE Point;
IMPORT
	Strings;
TYPE
	Instance* = POINTER TO LIMITED RECORD
		x-, y- : LONGINT; (* Instance variables *)
	END;
	
	PROCEDURE (self: Instance) Initialize*(x,y: LONGINT), NEW;
	BEGIN
		self.x := x;
		self.y := y
	END Initialize;
	
	(* constructor *)
	PROCEDURE New*(x, y: LONGINT): Instance;
	VAR
		point: Instance;
	BEGIN
		NEW(point);
		point.Initialize(x,y);
		RETURN point
	END New;
	
	(* methods *)
	PROCEDURE (self: Instance) Add*(other: Instance): Instance, NEW;
	BEGIN
		RETURN New(self.x + other.x,self.y + other.y);
	END Add;
	
	PROCEDURE (self: Instance) ToString*(): POINTER TO ARRAY OF CHAR, NEW;
	VAR
		xStr,yStr: ARRAY 64 OF CHAR;
		str: POINTER TO ARRAY OF CHAR;
	BEGIN
		Strings.IntToString(self.x,xStr);
		Strings.IntToString(self.y,yStr);
		NEW(str,128);str^ := "@(" +xStr$ + "," + yStr$ + ")";
		RETURN str
	END ToString;
END Point.
