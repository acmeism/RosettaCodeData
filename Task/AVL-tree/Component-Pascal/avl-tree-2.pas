DEFINITION RosettaAVLTrees;

	TYPE
		Tree = POINTER TO Node;
		Node = ABSTRACT RECORD (Order)
			(IN n: Node) Alloc- (): Tree, NEW, ABSTRACT;
			(IN n: Node) Delete (t: Tree): Tree, NEW;
			(IN t: Node) Init (): Tree, NEW;
			(IN n: Node) Insert (t: Tree): Tree, NEW;
			(IN n: Node) Lookup (t: Tree): BOOLEAN, NEW;
			(IN t: Node) Tail (): Tree, NEW
		END;

		Out = ABSTRACT RECORD
			(IN o: Out) Draw (t: Tree), NEW;
			(IN o: Out) Int- (i: INTEGER), NEW, ABSTRACT;
			(IN o: Out) Ln-, NEW, ABSTRACT;
			(IN o: Out) Node- (IN n: Node), NEW, ABSTRACT;
			(IN o: Out) Str- (s: ARRAY OF CHAR), NEW, ABSTRACT
		END;

	PROCEDURE Ordered (t: Tree): BOOLEAN;

END RosettaAVLTrees.
