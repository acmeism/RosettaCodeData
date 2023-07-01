datatype 'a nestedList =
	  L of 'a			(* leaf *)
	| N of 'a nestedList list	(* node *)
