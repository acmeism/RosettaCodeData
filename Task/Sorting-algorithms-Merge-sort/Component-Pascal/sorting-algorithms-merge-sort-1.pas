MODULE RosettaMergeSort;

	TYPE Template* = ABSTRACT RECORD END;

	(* Abstract Procedures: *)

	(* Return TRUE if `front` comes before `rear` in the sorted order, FALSE otherwise *)
	(* For the sort to be stable `front` comes before `rear` if they are equal *)
	PROCEDURE (IN t: Template) Pre- (front, rear: ANYPTR): BOOLEAN, NEW, ABSTRACT;

	(* Return the next element in the list after `s` *)
	PROCEDURE (IN t: Template) Suc- (s: ANYPTR): ANYPTR, NEW, ABSTRACT;

	(* Update the next pointer of `s` to the value of `next` -  Return the modified `s` *)
	PROCEDURE (IN t: Template) Set- (s, next: ANYPTR): ANYPTR, NEW, ABSTRACT;

	(* Return the total number of elements in the list starting from `s` *)
	PROCEDURE (IN t: Template) Length* (s: ANYPTR): INTEGER, NEW;
		VAR n: INTEGER;
	BEGIN
		n := 0;
		WHILE s # NIL DO
			INC(n);
			s := t.Suc(s)
		END;
		RETURN n
	END Length;

	(* Merge sorted lists `front` and `rear` -  Return the merged sorted list *)
	PROCEDURE (IN t: Template) Merge (front, rear: ANYPTR): ANYPTR, NEW;
	BEGIN
		IF front = NIL THEN RETURN rear END;
		IF rear = NIL THEN RETURN front END;
		IF t.Pre(front, rear) THEN
			RETURN t.Set(front, t.Merge(t.Suc(front), rear))
		ELSE
			RETURN t.Set(rear, t.Merge(front, t.Suc(rear)))
		END
	END Merge;

	(* Perform a merge sort on `s` -  Return the sorted list *)
	PROCEDURE (IN t: Template) Sort* (s: ANYPTR): ANYPTR, NEW;

		(* Take a positive integer `n` and an occupied list `s` *)
		(* Sort the initial segment of `s` of length `n` and return the result *)
		(* Update `s` to the list which remain when the first `n` elements are removed *)
		PROCEDURE TakeSort (n: INTEGER; VAR s: ANYPTR): ANYPTR;
			VAR k: INTEGER; h, front, rear: ANYPTR;
		BEGIN
			IF n = 1 THEN (* base case: if n = 1, return the head of `s` *)
				h := s; s := t.Suc(s); RETURN t.Set(h, NIL)
			END;
			(* Divide the first n elements of the list into two sorted halves *)
			k := n DIV 2;
			front := TakeSort(k, s);
			rear := TakeSort(n - k, s);
			RETURN t.Merge(front, rear) (* Merge and return the halves *)
		END TakeSort;

	BEGIN
		IF s = NIL THEN RETURN NIL END; (* If `s` in empty, return `s` *)
		(* Calculate the length of the list and call TakeSort *)
		RETURN TakeSort(t.Length(s), s) (* Return the sorted list *)
	END Sort;

END RosettaMergeSort.
