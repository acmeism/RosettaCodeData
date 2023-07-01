(* Abstract type *)
Object = POINTER TO ABSTRACT RECORD END;
	
(* Integer inherits Object *)
Integer = POINTER TO RECORD (Object)
	i: INTEGER
END;
(* Point inherits Object *)
Point = POINTER TO RECORD (Object)
	x,y: REAL
END;
