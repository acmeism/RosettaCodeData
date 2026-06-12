DEFINITION RosettaVLists;

	TYPE
		Accum = ABSTRACT RECORD
			(VAR a: Accum) Do- (e: Element), NEW, ABSTRACT
		END;

		Element = CHAR;

		List = RECORD
			length-: INTEGER;
			(IN l: List) Car (): Element, NEW;
			(VAR l: List) Cdr, NEW;
			(VAR l: List) Cons (e: Element), NEW;
			(IN l: List) Expose (IN o: Out), NEW;
			(IN l: List) FoldR (VAR a: Accum), NEW;
			(VAR l: List) Init, NEW;
			(IN l: List) Nth (n: INTEGER): Element, NEW;
			(VAR l: List) NthCdr (n: INTEGER), NEW
		END;

		Out = ABSTRACT RECORD
			(IN o: Out) Char- (e: Element), NEW, ABSTRACT
		END;

END RosettaVLists.
