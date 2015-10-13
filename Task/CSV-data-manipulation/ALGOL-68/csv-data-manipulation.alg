# count occurrances of a char in string #
PROC char count = (CHAR c, STRING str) INT:
   BEGIN
      INT count := 0;
      FOR i TO UPB str DO
	 IF c = str[i] THEN count +:= 1
	 FI
      OD;
      count
   END;

# split string on separator #
PROC char split = (STRING str, CHAR sep) FLEX[]STRING :
   BEGIN
      INT strlen := UPB str, cnt := 0;
      INT len, p;
      INT start := 1;
      [char count (sep, str) + 1] STRING list;
      WHILE start <= strlen ANDF char in string (sep, p, str[start:]) DO
	 p +:= start - 1;
	 list[cnt +:= 1] := str[start:p-1];
	 start := p + 1
      OD;
      IF cnt = 0 THEN list[cnt +:= 1] := str
      ELIF start <= UPB str + 1 THEN list[cnt +:= 1] := str[start:]
      FI;
      list
   END;

PROC join = ([]STRING words, STRING sep) STRING:
   IF UPB words > 0 THEN
      STRING str := words [1];
      FOR i FROM 2 TO UPB words DO
	 str +:= sep + words[i]
      OD;
      str
   ELSE
      ""
   FI;

# read a line from file #
PROC readline = (REF FILE f) STRING:
   BEGIN
      STRING line;
      get (f, line); new line (f);
      line
   END;

# Add one item to tuple #
OP +:= = (REF FLEX[]STRING tuple, STRING item) VOID:
   BEGIN
      [UPB tuple+1]STRING new;
      new[:UPB tuple] := tuple;
      new[UPB new] := item;
      tuple := new
   END;

# convert signed number TO INT #
OP TOINT = (STRING str) INT:
   BEGIN
      INT n := 0, sign := 1;
      FOR i TO UPB str WHILE sign /= 0 DO
	 IF is digit (str[i]) THEN n := n * 10 + ABS str[i] - ABS "0"
	 ELIF i = 1 AND str[i] = "-" THEN sign := -1
	 ELIF i /= 1 OR str[i] /= "+" THEN sign := 0
	 FI
      OD;
      n * sign
   END;

OP STR = (INT i) STRING: whole (i,0);

# The main program #
FILE foo;
open (foo, "CSV_data_manipulation.data", stand in channel);
FLEX[0]STRING header := char split (readline (foo), ",");
header +:= "SUM";
print ((join (header, ","), new line));
WHILE NOT end of file (foo) DO
   FLEX[0]STRING fields := char split (readline (foo), ",");
   INT sum := 0;
   FOR i TO UPB fields DO
      sum +:= TOINT fields[i]
   OD;
   fields +:= STR sum;
   print ((join (fields, ","), new line))
OD;
close (foo)
