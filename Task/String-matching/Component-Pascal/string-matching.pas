MODULE StringMatch;
IMPORT StdLog,Strings;
CONST
	strSize = 1024;
	patSize = 256;

TYPE
	Matcher* = POINTER TO LIMITED RECORD
		str: ARRAY strSize OF CHAR;
		pat: ARRAY patSize OF CHAR;
		pos: INTEGER
	END;

PROCEDURE NewMatcher*(IN str: ARRAY OF CHAR): Matcher;
VAR
	m: Matcher;
BEGIN
	NEW(m);m.str := str$;m.pos:= 0;
	RETURN m
END NewMatcher;

PROCEDURE (m: Matcher) Match*(IN pat: ARRAY OF CHAR): INTEGER,NEW;
VAR
	pos: INTEGER;
BEGIN
	m.pat := pat$;
	pos := m.pos;
	Strings.Find(m.str,m.pat,pos,m.pos);
	RETURN m.pos
END Match;

PROCEDURE (m: Matcher) Next*(): INTEGER, NEW;
VAR
	pos: INTEGER;
BEGIN
	pos := m.pos + LEN(m.pat$);
	Strings.Find(m.str,m.pat,pos,m.pos);
	RETURN m.pos;
END Next;

(* Some Helper functions based on Strings module *)
PROCEDURE StartsWith(IN str: ARRAY OF CHAR;IN pat: ARRAY OF CHAR): BOOLEAN;
VAR
	pos: INTEGER;
BEGIN
	Strings.Find(str,pat,0,pos);
	RETURN pos = 0
END StartsWith;

PROCEDURE Contains(IN str: ARRAY OF CHAR;IN pat: ARRAY OF CHAR; OUT pos: INTEGER): BOOLEAN;
BEGIN
	Strings.Find(str,pat,0,pos);
	RETURN pos >= 0
END Contains;

PROCEDURE EndsWith(IN str: ARRAY OF CHAR;IN pat: ARRAY OF CHAR): BOOLEAN;
VAR
	pos: INTEGER;
BEGIN
	Strings.Find(str,pat,0,pos);
	RETURN pos + LEN(pat$) = LEN(str$)
END EndsWith;

PROCEDURE Do*;
CONST
	aStr = "abcdefghijklmnopqrstuvwxyz";
VAR
	pat: ARRAY 128 OF CHAR;
	res: BOOLEAN;
	at: INTEGER;
	m: Matcher;
BEGIN
	(* StartsWith *)
	pat := "abc";
	StdLog.String(aStr + " startsWith " + pat + " :>");StdLog.Bool(StartsWith(aStr,pat));StdLog.Ln;
	pat := "cba";
	StdLog.String(aStr + " startsWith " + pat + " :>");StdLog.Bool(StartsWith(aStr,pat));StdLog.Ln;
	pat := "def";
	StdLog.String(aStr + " startsWith " + pat + " :>");StdLog.Bool(StartsWith(aStr,pat));StdLog.Ln;
	StdLog.Ln;
	(* Contains *)
	pat := 'def';
	StdLog.String(aStr + " contains " + pat + " :>");StdLog.Bool(Contains(aStr,pat,at));
	StdLog.String(" at: ");StdLog.Int(at);StdLog.Ln;
	pat := 'efd';
	StdLog.String(aStr + " contains " + pat + " :>");StdLog.Bool(Contains(aStr,pat,at));
	StdLog.String(" at: ");StdLog.Int(at);StdLog.Ln;	
	pat := 'abc';
	StdLog.String(aStr + " contains " + pat + " :>");StdLog.Bool(Contains(aStr,pat,at));
	StdLog.String(" at: ");StdLog.Int(at);StdLog.Ln;
	pat := 'xyz';
	StdLog.String(aStr + " contains " + pat + " :>");StdLog.Bool(Contains(aStr,pat,at));
	StdLog.String(" at: ");StdLog.Int(at);StdLog.Ln;
	StdLog.Ln;
	(* EndsWith *)
	pat := 'xyz';
	StdLog.String(aStr + " endsWith " + pat + " :>");StdLog.Bool(EndsWith(aStr,pat));StdLog.Ln;
	pat := 'zyx';
	StdLog.String(aStr + " endsWith " + pat + " :>");StdLog.Bool(EndsWith(aStr,pat));StdLog.Ln;
	pat := 'abc';
	StdLog.String(aStr + " endsWith " + pat + " :>");StdLog.Bool(EndsWith(aStr,pat));StdLog.Ln;
	pat:= 'def';
	StdLog.String(aStr + " endsWith " + pat + " :>");StdLog.Bool(EndsWith(aStr,pat));StdLog.Ln;
	StdLog.Ln;
	
	m := NewMatcher("abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz");
	StdLog.String("Matching 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz' against 'abc':> ");
	StdLog.Ln;
	StdLog.String("Match at: ");StdLog.Int(m.Match("abc"));StdLog.Ln;
	StdLog.String("Match at: ");StdLog.Int(m.Next());StdLog.Ln;
	StdLog.String("Match at: ");StdLog.Int(m.Next());StdLog.Ln
END Do;
END StringMatch.
