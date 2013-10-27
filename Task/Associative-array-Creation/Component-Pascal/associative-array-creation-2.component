MODULE BbtAssociativeArrays;
IMPORT StdLog, Collections, Boxes;

PROCEDURE Do*;
VAR
	hm : Collections.HashMap;
	o : Boxes.Object;
	keys, values: POINTER TO ARRAY OF Boxes.Object;
	i: INTEGER;
	
BEGIN
	hm := Collections.NewHashMap(1009);
	o := hm.Put(Boxes.NewString("first"),Boxes.NewInteger(1));
	o := hm.Put(Boxes.NewString("second"),Boxes.NewInteger(2));
	o := hm.Put(Boxes.NewString("third"),Boxes.NewInteger(3));
	o := hm.Put(Boxes.NewString("one"),Boxes.NewInteger(1));
	
	StdLog.String("size: ");StdLog.Int(hm.size);StdLog.Ln;
	
END Do;

END BbtAssociativeArrays.
