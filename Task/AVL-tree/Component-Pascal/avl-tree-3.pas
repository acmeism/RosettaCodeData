MODULE RosettaAVLTreesUse;

	IMPORT Set := RosettaAVLTrees, Log := StdLog;

	TYPE
		Height = RECORD (Set.Node) height: INTEGER END;
		(* Note that Set.Node already contains an integer field `height`. *)
		(* It does not cause a duplicate field error as it is hidden from this module *)

		Out = RECORD (Set.Out) END; (* Used for output by the `Draw` procedure *)

	(* The following three procedures are implemented here for use by Set.Node *)

	(* Compares one node with another and returns a boolean value based on which is less *)
	PROCEDURE (IN h: Height) Less- (IN n: Set.Node): BOOLEAN;
	BEGIN RETURN h.height < n(Height).height END Less;

	(* Compares one node with another and returns a boolean value based on which is more *)
	PROCEDURE (IN h: Height) More- (IN n: Set.Node): BOOLEAN;
	BEGIN RETURN h.height > n(Height).height END More;

	(* Creates a new root node *)
	PROCEDURE (IN h: Height) Alloc- (): Set.Tree;
		VAR r: POINTER TO Height;
	BEGIN NEW(r); r.height := h.height; RETURN r END Alloc;

	(* The following four procedures are implemented here for use by Set.Out *)

	(* Writes a string *)
	PROCEDURE (IN o: Out) Str- (s: ARRAY OF CHAR);
	BEGIN Log.String(s) END Str;

	(* Writes an integer *)
	PROCEDURE (IN o: Out) Int- (i: INTEGER);
	BEGIN Log.IntForm(i, Log.decimal, 0, ' ', Log.hideBase) END Int;

	(* Writes a  new-line *)
	PROCEDURE (IN o: Out) Ln-; BEGIN Log.Ln END Ln;

	(* Writes a  node *)
	PROCEDURE (IN o: Out) Node- (IN n: Set.Node);
	BEGIN
		Log.IntForm(n(Height).height, Log.decimal, 0, ' ', Log.hideBase)
	END Node;

	PROCEDURE Use*;
		TYPE BAD = POINTER TO Height;
		VAR h: Height; hs, save: Set.Tree; i: INTEGER; o: Out;
	BEGIN
		h.height := 10; hs := h.Insert(hs);
		FOR i := 0 TO 9 DO h.height := i; hs := h.Insert(hs) END;
		o.Draw(hs); Log.Ln; Log.Ln;
		save := hs;
		FOR i := 0 TO 9 DO h.height := i; hs := h.Delete(hs) END;
		o.Draw(hs); Log.Ln; Log.Ln;
		o.Draw(save); Log.Ln; Log.Ln;  (* Tree demonstrates persistence *)
		ASSERT(Set.Ordered(save));  (* This ASSERT succeeds *)
		save(BAD).height := 11;  (* UNSAFE STATEMENT *)
		o.Draw(save);
		ASSERT(Set.Ordered(save))  (* This ASSERT fails *)
	END Use;

END RosettaAVLTreesUse.
