MODULE RosettaMergeSortUse;

	(* Import Modules: *)
	

	IMPORT Sort := RosettaMergeSort, Out;

	(* Type Definitions: *)
	TYPE
		(* a linked list node containing an integer and a pointer to the next node *)
		List = POINTER TO RECORD
			value: INTEGER;
			next: List
		END;

		(* Implement the abstract record type Sort.Template *)
		Template = RECORD (Sort.Template) END;

	(* Abstract Procedure Implementations: *)

	(* Compare integers in the list nodes to determine their order in the sorted list *)
	(* For the sort to be stable `front` comes before `rear` if they are equal *)
	PROCEDURE (IN t: Template) Before (front, rear: ANYPTR): BOOLEAN;
	BEGIN RETURN front(List).value <= rear(List).value END Before;

	(* Return the next node in the linked list *)
	PROCEDURE (IN t: Template) Next (s: ANYPTR): ANYPTR;
	BEGIN RETURN s(List).next END Next;

	(* Set the next pointer of a list node *)
	PROCEDURE (IN t: Template) Set (s, next: ANYPTR): ANYPTR;
	BEGIN
		IF next = NIL THEN
			s(List).next := NIL
		ELSE
			s(List).next := next(List)
		END;
		RETURN s
	END Set;

	(* Helper Procedures: *)

	(* Prefix a node to a list *)
	PROCEDURE Prefix (value: INTEGER; s: List): List;
		VAR new: List;
	BEGIN
		NEW(new); new.value := value; new.next := s; RETURN new
	END Prefix;

	(* Write a list *)
	PROCEDURE Show (s: List);
		VAR count: INTEGER;
	BEGIN
		count := 0;
		WHILE s # NIL DO
			IF count = 10 THEN
					Out.Ln; (* Insert a newline after displaying 10 numbers *)
					count := 0
			END;
			Out.Int(s.value, 4);
			s := s.next;
			INC(count)
		END
	END Show;

	(* Main Procedure: *)
	PROCEDURE Use*;
		VAR t: Template; s: List;
		(* Calls Prefix to add integers to the beginning of the list `s` *)
		PROCEDURE b (value: INTEGER); BEGIN s := Prefix(value, s) END b;
	BEGIN
		(* Use the `b` procedure to add the integers to the list `s` *)
		b(663); b(085); b(534); b(066); b(038); b(323); b(727); b(651);
		b(625); b(706); b(149); b(956); b(804); b(626); b(106); b(230);
		b(314); b(249); b(758); b(236); b(775); b(399); b(701); b(296);
		b(770); b(380); b(403); b(760); b(159); b(551); b(153); b(297);
		b(130); b(866); b(937); b(226); b(298); b(029); b(149); b(381);
		b(590); b(255); b(101); b(485); b(801); b(223); b(645); b(458);
		b(068);  b(683);
		Out.String("Before:"); Out.Ln;
		Show(s); Out.Ln;
		s := t.Sort(s)(List);
		Out.String("After:"); Out.Ln;
		Show(s); Out.Ln
	END Use;

END RosettaMergeSortUse.Use
