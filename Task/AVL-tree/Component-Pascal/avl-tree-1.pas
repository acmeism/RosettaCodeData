MODULE RosettaAVLTrees;

	(* An implementation of persistent AVL Trees *)

	TYPE
		Order = ABSTRACT RECORD END;
		Tree* = POINTER TO Node;
		Node* = ABSTRACT RECORD (Order)
			left, right: Tree;
			height: INTEGER
		END; (* Contains the left and right child nodes and the height of the node *)

		Out* = ABSTRACT RECORD END; (* Used for output by the `Draw` procedure *)

		Void = RECORD (Order) END; (* Used by the `Ordered` procedure *)

	(* The following abstract procedures must be implemented by a user of `Node` *)
	(* They must be implemented correctly for the AVL tree to work *)

	(* Compares one node with another and returns a boolean value based on which is less *)
	PROCEDURE (IN n: Order) Less- (IN m: Node): BOOLEAN, NEW, ABSTRACT;
	(* Compares one node with another and returns a boolean value based on which is more *)
	PROCEDURE (IN n: Order) More- (IN m: Node): BOOLEAN, NEW, ABSTRACT;
	(* Creates a new root node *)
	PROCEDURE (IN n: Node) Alloc- (): Tree, NEW, ABSTRACT;

	(* Returns TRUE if n is in the tree t, FALSE otherwise *)
	PROCEDURE (IN n: Node) Lookup* (t: Tree): BOOLEAN, NEW;
	BEGIN
		IF t = NIL THEN RETURN FALSE END;
		IF n.Less(t) THEN RETURN n.Lookup(t.left) END;
		IF n.More(t) THEN RETURN n.Lookup(t.right) END;
		RETURN TRUE
	END Lookup;

	(* Returns the height of the AVL tree t *)
	PROCEDURE Height (t: Tree): INTEGER;
	BEGIN
		IF t = NIL THEN RETURN 0 END;
		RETURN t.height
	END Height;

	(* Creates and returns a new Node with the given children *)
	PROCEDURE (IN n: Node) New (left, right: Tree): Tree, NEW;
		VAR t: Tree;
	BEGIN
		t := n.Alloc(); (* Create a new root node *)
		t.left := left; t.right := right; (* set the children *)
		(* set the height of the node based on its children *)
		t.height := MAX(Height(left), Height(right)) + 1;
		RETURN t
	END New;

	(* Returns the difference in height between the left and right children of a node *)
	PROCEDURE Slope (l, r: Tree): INTEGER;
	BEGIN RETURN Height(l) - Height(r) END Slope;

	(* Returns an AVL tree if it is right-heavy *)
	PROCEDURE (IN n: Node) BalL (l, r: Tree): Tree, NEW;
	BEGIN
		IF Slope(l, r) =  - 2 THEN
			IF Slope(r.left, r.right) = 1 THEN
				RETURN r.left.New(n.New(l, r.left.left),
													r.New(r.left.right, r.right))
			END;
			RETURN r.New(n.New(l, r.left), r.right)
		END;
		RETURN n.New(l, r)
	END BalL;

	(* Returns an AVL tree if it is left-heavy *)
	PROCEDURE (IN n: Node) BalR (l, r: Tree): Tree, NEW;
	BEGIN
		IF Slope(l, r) = 2 THEN
			IF Slope(l.left, l.right) = - 1 THEN
				RETURN l.right.New(l.New(l.left, l.right.left),
													 n.New(l.right.right, r))
			END;
			RETURN l.New(l.left, n.New(l.right, r))
		END;
		RETURN n.New(l, r)
	END BalR;

	(* Returns the AVL tree t with the node n *)
	PROCEDURE (IN n: Node) Insert* (t: Tree): Tree, NEW;
	BEGIN
		IF t = NIL THEN RETURN n.New(NIL, NIL) END;
		IF n.Less(t) THEN RETURN t.BalR(n.Insert(t.left), t.right) END;
		IF n.More(t) THEN RETURN t.BalL(t.left, n.Insert(t.right)) END;
		RETURN t
	END Insert;

	(* Returns the leftmost node of the non-empty tree t *)
	PROCEDURE (t: Tree) Head (): Tree, NEW;
	BEGIN
		IF t.left = NIL THEN RETURN t END;
		RETURN t.left.Head()
	END Head;

	(* Returns the rightmost node of the non-empty tree t *)
	PROCEDURE (t: Tree) Last (): Tree, NEW;
	BEGIN
		IF t.right = NIL THEN RETURN t END;
		RETURN t.right.Last()
	END Last;

	(* Returns the AVL tree t without the leftmost node *)
	PROCEDURE (IN t: Node) Tail* (): Tree, NEW;
	BEGIN
		IF t.left = NIL THEN RETURN t.right END;
		RETURN t.BalL(t.left.Tail(), t.right)
	END Tail;

	(* Returns the AVL tree t without the rightmost node *)
	PROCEDURE (IN t: Node) Init* (): Tree, NEW;
	BEGIN
		IF t.right = NIL THEN RETURN t.left END;
		RETURN t.BalR(t.left, t.right.Init())
	END Init;

	(* Returns the AVL tree t without node n *)
	PROCEDURE (IN n: Node) Delete* (t: Tree): Tree, NEW;
	BEGIN
		IF t = NIL THEN RETURN NIL END;
		IF n.Less(t) THEN RETURN t.BalL(n.Delete(t.left), t.right) END;
		IF n.More(t) THEN RETURN t.BalR(t.left, n.Delete(t.right)) END;
		IF Slope(t.left, t.right) = 1 THEN
			RETURN t.left.Last().BalL(t.left.Init(), t.right)
		END;
		IF t.right = NIL THEN RETURN t.left END;
		RETURN t.right.Head().BalR(t.left, t.right.Tail())
	END Delete;

	(* The following procedures are used for debugging *)

	PROCEDURE (IN n: Void) Less- (IN m: Node): BOOLEAN;
	BEGIN RETURN TRUE END Less;

	PROCEDURE (IN n: Void) More- (IN m: Node): BOOLEAN;
	BEGIN RETURN TRUE END More;

	(* Returns TRUE if the AVL tree t is ordered, FALSE otherwise *)
	PROCEDURE Ordered* (t: Tree): BOOLEAN;
		VAR void: Void;

		PROCEDURE Bounded (IN lo, hi: Order; t: Tree): BOOLEAN;
		BEGIN
			IF t = NIL THEN RETURN TRUE END;
			RETURN lo.Less(t) & hi.More(t) &
						 Bounded(lo, t, t.left) & Bounded(t, hi, t.right)
		END Bounded;

	BEGIN RETURN Bounded(void, void, t) END Ordered;

	(* The following abstract procedures must be implemented by a user of `Out` *)

	(* Writes a string *)
	PROCEDURE (IN o: Out) Str- (s: ARRAY OF CHAR), NEW, ABSTRACT;
	(* Writes an integer *)
	PROCEDURE (IN o: Out) Int- (i: INTEGER), NEW, ABSTRACT;
	(* Writes a  new-line *)
	PROCEDURE (IN o: Out) Ln-, NEW, ABSTRACT;
	(* Writes a  node *)
	PROCEDURE (IN o: Out) Node- (IN n: Node), NEW, ABSTRACT;

	(* Writes a tree (rotated) *)
	PROCEDURE (IN o: Out) Draw* (t: Tree), NEW;

		PROCEDURE Bars (bars, bar: ARRAY OF CHAR);
		BEGIN
			IF LEN(bars + bar) # 0 THEN o.Str(bars + "+--") END
		END Bars;

		PROCEDURE Do (lBar, rBar, bars: ARRAY OF CHAR; t: Tree);
		BEGIN
			IF t = NIL THEN Bars(bars, lBar); o.Str("|"); o.Ln
			ELSIF (t.left = NIL) & (t.right = NIL) THEN
				Bars(bars, lBar); o.Node(t); o.Ln
			ELSE
				Do("|  ", "   ", bars + rBar, t.right);
				o.Str(bars + rBar + "|"); o.Ln;
				Bars(bars, lBar); o.Node(t);
				IF Slope(t.left, t.right) # 0 THEN
					o.Str(" ["); o.Int(Slope(t.left, t.right)); o.Str("]")
				END;
				o.Ln;
				o.Str(bars + lBar + "|"); o.Ln;
				Do("   ", "|  ", bars + lBar, t.left)
			END
		END Do;

	BEGIN
		Do("", "", "", t)
	END Draw;

END RosettaAVLTrees.
