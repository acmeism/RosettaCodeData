MODULE RosettaMergeSortUse;

	(* Import Modules: *)
	IMPORT Sort := RosettaMergeSort, Out;

	(* Type Definitions: *)
	TYPE
		(* a character list *)
		List = POINTER TO RECORD
			value: CHAR;
			next: List
		END;

		(* Implement the abstract record type Sort.Template *)
		Order = ABSTRACT RECORD (Sort.Template) END;
		Asc = RECORD (Order) END;
		Bad = RECORD (Order) END;
		Desc = RECORD (Order) END;

	(* Abstract Procedure Implementations: *)

	(* Return the next node in the linked list *)
	PROCEDURE (IN t: Order) Next (s: ANYPTR): ANYPTR;
	BEGIN RETURN s(List).next END Next;

	(* Set the next pointer of list item `s` to `next` -  Return the updated `s` *)
	PROCEDURE (IN t: Order) Set (s, next: ANYPTR): ANYPTR;
	BEGIN
		IF next = NIL THEN s(List).next := NIL
					  ELSE s(List).next := next(List) END;
		RETURN s
	END Set;

	(* Ignoring case, compare characters to determine ascending order in the sorted list *)
	(* For the sort to be stable `front` comes before `rear` if they are equal *)
	PROCEDURE (IN t: Asc) Before (front, rear: ANYPTR): BOOLEAN;
	BEGIN
		RETURN CAP(front(List).value) <= CAP(rear(List).value)
	END Before;

	(* Unstable sort!!! *)
	PROCEDURE (IN t: Bad) Before (front, rear: ANYPTR): BOOLEAN;
	BEGIN
		RETURN CAP(front(List).value) < CAP(rear(List).value)
	END Before;

	(* Ignoring case, compare characters to determine descending order in the sorted list *)
	(* For the sort to be stable `front` comes before `rear` if they are equal *)
	PROCEDURE (IN t: Desc) Before (front, rear: ANYPTR): BOOLEAN;
	BEGIN
		RETURN CAP(front(List).value) >= CAP(rear(List).value)
	END Before;

	(* Helper Procedures: *)

	(* Takes a string and converts it into a linked list of characters *)
	PROCEDURE Explode (str: ARRAY OF CHAR): List;
		VAR i: INTEGER; h, t: List;
	BEGIN
		i := LEN(str$);
		WHILE i # 0 DO
			t := h; NEW(h);
			DEC(i); h.value := str[i];
			h.next := t
		END;
		RETURN h
	END Explode;

	(* Outputs the characters in a linked list as a string in quotes *)
	PROCEDURE Show (s: List);
		VAR i: INTEGER;
	BEGIN
		Out.Char('"');
		WHILE s # NIL DO Out.Char(s.value); s := s.next END;
		Out.Char('"')
	END Show;

	(* Main Procedure: *)
	PROCEDURE Use*;
		VAR a: Asc; b: Bad; d: Desc; s: List;
	BEGIN
		s := Explode("A quick brown fox jumps over the lazy dog");
		Out.String("Before:"); Out.Ln; Show(s); Out.Ln;
		s := a.Sort(s)(List); (* Ascending stable sort *)
		Out.String("After Asc:"); Out.Ln; Show(s); Out.Ln;
		s := b.Sort(s)(List); (* Ascending unstable sort *)
		Out.String("After Bad:"); Out.Ln; Show(s); Out.Ln;
		s := d.Sort(s)(List); (* Descending stable sort *)
		Out.String("After Desc:"); Out.Ln; Show(s); Out.Ln
	END Use;


END RosettaMergeSortUse.
