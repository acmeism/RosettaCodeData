(* create first array and assign elements *)
-val first = Array.tabulate (10,fn x=>x+10) ;
val first = fromList[10, 11, 12, 13, 14, 15, 16, 17, 18, 19]: int array

(* assign to array 'second' *)
-val second=first ;
val second = fromList[10, 11, 12, 13, 14, 15, 16, 17, 18, 19]: int array

(* retrieve 5th element *)
-Array.sub(second,4);
val it = 14: int
