MODULE RosettaMergeSort;

	

	TYPE Template* = ABSTRACT RECORD END;

	(* Abstract Procedures: *)

	(* Return TRUE if list item`front` comes before list item `rear` in the sorted order, FALSE otherwise *)
	(* For the sort to be stable `front` comes before `rear` if they are equal *)
	PROCEDURE (IN t: Template) Before- (front, rear: ANYPTR): BOOLEAN, NEW, ABSTRACT;

	(* Return the next item in the list after `s` *)
	PROCEDURE (IN t: Template) Next- (s: ANYPTR): ANYPTR, NEW, ABSTRACT;

	(* Update the next pointer of list item `s` to the value of list `next` -  Return the modified `s` *)
	PROCEDURE (IN t: Template) Set- (s, next: ANYPTR): ANYPTR, NEW, ABSTRACT;

	(* Merge sorted lists `front` and `rear` -  Return the merged sorted list *)
	PROCEDURE (IN t: Template) Merge (front, rear: ANYPTR): ANYPTR, NEW;
	BEGIN
		IF front = NIL THEN RETURN rear END;
		IF rear = NIL THEN RETURN front END;
		IF t.Before(front, rear) THEN
			RETURN t.Set(front, t.Merge(t.Next(front), rear))
		ELSE
			RETURN t.Set(rear, t.Merge(front, t.Next(rear)))
		END
	END Merge;

	(* Sort the first `n` items in the list `s` and drop them from `s` *)
	(* Return the sorted `n` items *)
	PROCEDURE (IN t: Template) TakeSort (n: INTEGER; VAR s: ANYPTR): ANYPTR, NEW;
		VAR k: INTEGER; front, rear: ANYPTR;
	BEGIN
		IF n = 1 THEN (* base case: if `n` is 1, return the head of `s` *)
			front := s; s := t.Next(s); RETURN t.Set(front, NIL)
		END;
		(* Divide the first `n` items of `s` into two sorted parts *)
		k := n DIV 2;
		front := t.TakeSort(k, s);
		rear := t.TakeSort(n - k, s);
		RETURN t.Merge(front, rear) (* Return the merged parts *)
	END TakeSort;

	(* Perform a merge sort on `s` -  Return the sorted list *)
	PROCEDURE (IN t: Template) Sort* (s: ANYPTR): ANYPTR, NEW;
		VAR n: INTEGER; r: ANYPTR;
	BEGIN
		IF s = NIL THEN RETURN s END; (* If `s` is empty, return `s` *)
		(* Count of items in `s` *)
		n := 0; r := s; (* Initialize the item to be counted to `s` *)
		WHILE r # NIL DO INC(n); r := t.Next(r) END;
		RETURN t.TakeSort(n, s) (* Return the sorted list *)
	END Sort;

END RosettaMergeSort.
