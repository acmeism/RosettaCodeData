DEFINITION Collections;

	IMPORT Boxes;

	CONST
		notFound = -1;

	TYPE
		Hash = POINTER TO RECORD
			cap-, size-: INTEGER;
			(h: Hash) ContainsKey (k: Boxes.Object): BOOLEAN, NEW;
			(h: Hash) Get (k: Boxes.Object): Boxes.Object, NEW;
			(h: Hash) IsEmpty (): BOOLEAN, NEW;
			(h: Hash) Put (k, v: Boxes.Object): Boxes.Object, NEW;
			(h: Hash) Remove (k: Boxes.Object): Boxes.Object, NEW;
			(h: Hash) Reset, NEW
		END;

		HashMap = POINTER TO RECORD
			cap-, size-: INTEGER;
			(hm: HashMap) ContainsKey (k: Boxes.Object): BOOLEAN, NEW;
			(hm: HashMap) ContainsValue (v: Boxes.Object): BOOLEAN, NEW;
			(hm: HashMap) Get (k: Boxes.Object): Boxes.Object, NEW;
			(hm: HashMap) IsEmpty (): BOOLEAN, NEW;
			(hm: HashMap) Keys (): POINTER TO ARRAY OF Boxes.Object, NEW;
			(hm: HashMap) Put (k, v: Boxes.Object): Boxes.Object, NEW;
			(hm: HashMap) Remove (k: Boxes.Object): Boxes.Object, NEW;
			(hm: HashMap) Reset, NEW;
			(hm: HashMap) Values (): POINTER TO ARRAY OF Boxes.Object, NEW
		END;

		LinkedList = POINTER TO RECORD
			first-, last-: Node;
			size-: INTEGER;
			(ll: LinkedList) Add (item: Boxes.Object), NEW;
			(ll: LinkedList) Append (item: Boxes.Object), NEW;
			(ll: LinkedList) AsString (): POINTER TO ARRAY OF CHAR, NEW;
			(ll: LinkedList) Contains (item: Boxes.Object): BOOLEAN, NEW;
			(ll: LinkedList) Get (at: INTEGER): Boxes.Object, NEW;
			(ll: LinkedList) IndexOf (item: Boxes.Object): INTEGER, NEW;
			(ll: LinkedList) Insert (at: INTEGER; item: Boxes.Object), NEW;
			(ll: LinkedList) IsEmpty (): BOOLEAN, NEW;
			(ll: LinkedList) Remove (item: Boxes.Object), NEW;
			(ll: LinkedList) RemoveAt (at: INTEGER), NEW;
			(ll: LinkedList) Reset, NEW;
			(ll: LinkedList) Set (at: INTEGER; item: Boxes.Object), NEW
		END;

		Vector = POINTER TO RECORD
			size-, cap-: LONGINT;
			(v: Vector) Add (item: Boxes.Object), NEW;
			(v: Vector) AddAt (item: Boxes.Object; i: INTEGER), NEW;
			(v: Vector) Contains (o: Boxes.Object): BOOLEAN, NEW;
			(v: Vector) Get (i: LONGINT): Boxes.Object, NEW;
			(v: Vector) IndexOf (o: Boxes.Object): LONGINT, NEW;
			(v: Vector) Remove (o: Boxes.Object), NEW;
			(v: Vector) RemoveIndex (i: LONGINT): Boxes.Object, NEW;
			(v: Vector) Set (i: LONGINT; o: Boxes.Object): Boxes.Object, NEW;
			(v: Vector) Trim, NEW
		END;

	PROCEDURE NewHash (cap: INTEGER): Hash;
	PROCEDURE NewHashMap (cap: INTEGER): HashMap;
	PROCEDURE NewLinkedList (): LinkedList;
	PROCEDURE NewVector (cap: INTEGER): Vector;

END Collections.
