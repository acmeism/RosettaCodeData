MODULE BbtAnagrams;
IMPORT StdLog,Files,Strings,Args;
CONST
	MAXPOOLSZ = 1024;

TYPE	
	Node = POINTER TO LIMITED RECORD;
		count: INTEGER;
		word: Args.String;
		desc: Node;
		next: Node;
	END;

	Pool = POINTER TO LIMITED RECORD
		capacity,max: INTEGER;
		words: POINTER TO ARRAY OF Node;
	END;

	PROCEDURE NewNode(word: ARRAY OF CHAR): Node;
	VAR
		n: Node;
	BEGIN
		NEW(n);n.count := 0;n.word := word$;
		n.desc := NIL;n.next := NIL;
		RETURN n
	END NewNode;

	PROCEDURE Index(s: ARRAY OF CHAR;cap: INTEGER): INTEGER;
	VAR
		i,sum: INTEGER;
	BEGIN
		sum := 0;
		FOR i := 0 TO  LEN(s$) DO
			INC(sum,ORD(s[i]))
		END;
		RETURN sum MOD cap
	END Index;

	PROCEDURE ISort(VAR s: ARRAY OF CHAR);
	VAR
        i, j: INTEGER;
        t: CHAR;
	BEGIN
        FOR i := 0 TO LEN(s$) - 1 DO
			j := i;
			t := s[j];
			WHILE (j > 0) & (s[j -1] > t) DO
					s[j] := s[j - 1];
					DEC(j)
			END;
			s[j] := t
        END
	END ISort;

	PROCEDURE SameLetters(x,y: ARRAY OF CHAR): BOOLEAN;
	BEGIN
        ISort(x);ISort(y);
        RETURN x = y
	END SameLetters;

	PROCEDURE NewPoolWith(cap: INTEGER): Pool;
	VAR
		i: INTEGER;
		p: Pool;
	BEGIN
		NEW(p);
		p.capacity := cap;
		p.max := 0;
		NEW(p.words,cap);
		i := 0;
		WHILE i < p.capacity DO
			p.words[i] := NIL;
			INC(i);
		END;
		RETURN p
	END NewPoolWith;

	PROCEDURE NewPool(): Pool;
	BEGIN
		RETURN NewPoolWith(MAXPOOLSZ);
	END NewPool;

	PROCEDURE (p: Pool) Add(w: ARRAY OF CHAR), NEW;
	VAR
		idx: INTEGER;
		iter,n: Node;
	BEGIN
		idx := Index(w,p.capacity);
		iter := p.words[idx];
		n := NewNode(w);
		WHILE(iter # NIL) DO
			IF SameLetters(w,iter.word) THEN
				INC(iter.count);
				IF iter.count > p.max THEN p.max := iter.count END;
				n.desc := iter.desc;
				iter.desc := n;
				RETURN
			END;
			iter := iter.next
		END;
		ASSERT(iter = NIL);
		n.next := p.words[idx];p.words[idx] := n
	END Add;

	PROCEDURE ShowAnagrams(l: Node);
	VAR
		iter: Node;
	BEGIN
		iter := l;
		WHILE iter # NIL DO
			StdLog.String(iter.word);StdLog.String(" ");
			iter := iter.desc
		END;
		StdLog.Ln
	END ShowAnagrams;

	PROCEDURE (p: Pool) ShowMax(),NEW;
	VAR
		i: INTEGER;
		iter: Node;
	BEGIN
		FOR i := 0 TO LEN(p.words) - 1 DO
			IF p.words[i] # NIL THEN
				iter := p.words^[i];
				WHILE iter # NIL DO
					IF iter.count = p.max THEN
						ShowAnagrams(iter);
					END;
					iter := iter.next
				END
			END
		END
	END ShowMax;
	
	PROCEDURE GetLine(rd: Files.Reader; OUT str: ARRAY OF CHAR);
	VAR
		i: INTEGER;
		b: BYTE;
	BEGIN
		rd.ReadByte(b);i := 0;
		WHILE (~rd.eof) & (i < LEN(str)) DO
			IF (b = ORD(0DX)) OR (b = ORD(0AX)) THEN str[i] := 0X; RETURN  END;
			str[i] := CHR(b);
			rd.ReadByte(b);INC(i)
		END;
		str[LEN(str) - 1] := 0X
	END GetLine;
	
	PROCEDURE DoProcess*;
	VAR
		params : Args.Params;
		loc: Files.Locator;
		fd: Files.File;
		rd: Files.Reader;
		line: ARRAY 81 OF CHAR;
		p: Pool;
	BEGIN
		Args.Get(params);
		IF params.argc = 1 THEN
		  loc := Files.dir.This("Bbt");
			fd := Files.dir.Old(loc,params.args[0]$,FALSE);
			StdLog.String("Processing: " + params.args[0]);StdLog.Ln;StdLog.Ln;
			rd := fd.NewReader(NIL);
			p := NewPool();
			REPEAT
				GetLine(rd,line);
				p.Add(line);
			UNTIL rd.eof;
			p.ShowMax()
		ELSE
			StdLog.String("Error: Missing file to process");StdLog.Ln
		END;
	END DoProcess;

END BbtAnagrams.
