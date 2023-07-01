CHAR line feed = REPR 10, carriage return = REPR 13;
STRING crlf = carriage return + line feed;
STRING domain = "rosettacode.org",
       page = "/mw/api.php?format=xml&action=query&generator=categorymembers&gcmtitle=Category:Programming%20Languages&gcmlimit=500&prop=categoryinfo";

# concatenate tuples #
OP + = ([]STRING a, b) []STRING:
   BEGIN
      [⌈a + ⌈b] STRING c;
      c[:⌈a] := a;
      c[⌈a+1:] := b;
      c
   END;

# count occurrances of string in string #
PROC count = (STRING sub, str) INT :
   BEGIN
      INT count := 0;
      IF UPB str ≥ UPB sub AND UPB str ≥ 1 THEN
	 INT p := 1; INT p0;
	 WHILE p + UPB sub - 1 <= UPB str ANDF (p0 := p; string in string (sub, p, str[p0:])) DO
            count +:= 1;
	    p +:= p0 + UPB sub - 1
	 OD
      FI;
      count
   END;

# split string into tuple #
PROC split = (STRING str, sep) FLEX[]STRING :
   BEGIN
      INT seplen = UPB sep, strlen = UPB str;
      INT cnt := 0, start := 1;
      INT p;
      [count (sep, str) + 1] STRING list;
      WHILE start ≤ strlen - (seplen - 1)
	 ANDF string in string (sep, p, str[start:]) DO
	    p +:= start - 1;
	    list[cnt +:= 1] := str[start:p-1];
	    start := p + seplen
      OD;
      IF cnt = 0 THEN list[cnt +:= 1] := str
      ELIF start ≤ strlen THEN list[cnt +:= 1] := str[start:]
      ELIF start = strlen + 1 AND seplen ≥ 1 THEN list[cnt +:= 1] := ""
      FI;
      list
   END;

# reverse strings in a TUPLE #
OP REVERSE = ([]STRING org) []STRING :
   BEGIN
      [UPB org]STRING new;
      FOR i TO UPB org DO
	 new[UPB org - (i - 1)] := org[i]
      OD;
      new
   END;

# convert unsigned number to INT #
OP TOINT = (STRING str) INT:
   BEGIN
      INT p := 1, len := UPB str;
      WHILE p ≤ len ANDF is space (str[p]) DO p +:= 1 OD;
      IF str[1] = "-" OR str[1] = "+" THEN
	 p +:= 1
      FI;
      INT n := 0;
      WHILE p ≤ len ANDF is space (str[p]) DO p +:= 1 OD;
      FOR i FROM p TO len WHILE is digit (str[i]) DO
	 n := n × 10 + ABS str[i] - ABS "0"
      OD;
      n
   END;

# pad to fixed width #
PROC field = (UNION (STRING,INT) x, INT w) STRING:
   BEGIN
      STRING s = (x | (INT i): whole (i,0), (STRING t): t);
      (w >= UPB s | " " * (w - UPB s)) + s
   END;

PROC get web page = (STRING host, path) STRING:
   BEGIN
      STRING reply;
      INT rc;
      # 'http content' sometimes fails with interrupted system call, so we loop until succeeding #
      WHILE
	 # 'http content' makes requests that are not accepted by rosettacode.org, so therefore the hack #
	 STRING hack = " HTTP/1.0" + crlf +
	               "Host: rosettacode.org" + crlf +
                       "User-Agent: rank_languages_by_popularity";
         rc := http content (reply, host, path + hack, 0);
	 rc = 4
         DO SKIP
      OD;
      IF rc = 0 AND grep in string ("^HTTP/[0-9.]+ 200", reply, NIL, NIL) = 0 THEN
	 INT p;
	 IF string in string (crlf + crlf, p, reply) THEN
	    STRING headers = reply[:p],
	           body = reply[p+4:];
	    body
	 ELSE
	    ""
	 FI
      ELSE
	 print (strerror (rc)); ""
      FI
   END;

# the main program rank languages by popularity starts here #
STRING gcmcontinue;
FLEX[0]STRING lines;

# get through API in chunks of 500 #
WHILE
   STRING body = get web page (domain, page + (gcmcontinue /= "" | "&gcmcontinue=" + gcmcontinue));
   INT b, e;
   gcmcontinue := (grep in string ("gcmcontinue=""([^""]+)", body, b, e) = 0 | body[b+13:e-1] | "");
   # split the XML into lines on </page> #
   lines := lines + split (body, "</page>");
   gcmcontinue /= "" DO SKIP
OD;

# Each line is one language,
  go through them and rewrite them to something we can sort #
FOR i TO UPB lines DO
   STRING line = lines[i];
   STRING title;
   INT pages := 0;
   INT b, e;
   # the two fields we are intrested in are title="Category:xxx", and pages="999" #
   IF grep in string ("title=""Category:[^""]+""", line, b, e) = 0 THEN
      title := line[b+16:e-1]
   FI;
   IF grep in string ("pages=""[0-9]+""", line, b, e) = 0 THEN
      pages := TOINT line[b+7:e-1]
   FI;
   lines[i] := field (pages, 6) + " " + title
OD;

lines := REVERSE SORT lines;

INT rank := 1;
BOOL tied := FALSE, lasttied := FALSE;
print ((new line, whole (UPB lines, 0), " languages", new line, new line));
FOR i TO UPB lines DO
   INT entries = TOINT lines[i][:6];
   STRING lang = lines[i][8:];
   IF entries > 0 THEN
      tied := i < UPB lines ANDF lines[i][:6] = lines[i+1][:6];
      print (("rank: ", field (rank,3), "  ", (tied OR lasttied | "[tied]" | " "*6),
              field ("(" + whole (entries,0) + " " + (entries = 1 | "entry)" | "entries)"), 20),
              "  ", lang, new line));
      IF NOT tied THEN rank +:= 1 FI;
      lasttied := tied
   FI
OD
