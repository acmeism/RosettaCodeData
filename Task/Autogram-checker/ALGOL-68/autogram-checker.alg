# string utilities #
OP LC = (CHAR ch) CHAR: IF ch >= "A" AND ch <= "Z" THEN REPR (ABS ch + 32) ELSE ch FI;
OP LC = (STRING s) STRING: (
  FLEX[UPB s]CHAR res;
  FOR i TO UPB s DO res[i] := LC s[i] OD;
  res);
OP INDEXOF = ([]STRING ss, STRING s) INT: (
  INT res := 0;
  FOR i TO UPB ss DO
    IF s = ss[i] THEN res := i; return FI
  OD;
  return: res);
PRIO INDEXOF = 7;
PROC split = (STRING s, []CHAR seps) []STRING:
  BEGIN
    # count... #
    INT n := 0;
    BOOL prev in sep := TRUE;
    FOR i TO UPB s DO
      BOOL in sep = char in string(s[i], LOC INT, seps);
      IF ~in sep AND prev in sep THEN n +:= 1 FI;
      prev in sep := in sep
    OD;
    # ...then fill #
    [n] STRING result;
    prev in sep := TRUE;
    INT start, idx := 1;
    FOR i TO UPB s DO
      BOOL in sep = char in string(s[i], LOC INT, seps);
      IF ~in sep AND prev in sep THEN start := i
      ELIF in sep AND ~prev in sep THEN
        result[idx] := s[start : i-1];
        idx +:= 1
      FI;
      prev in sep := in sep
    OD;
    IF idx = n THEN result[idx] := s[start : ] FI;
    result
  END;
# array comparison #
OP = = ([]INT a, []INT b) BOOL: (
  IF LWB a ~= LWB b OR UPB a ~= UPB b THEN return false FI;
  FOR i FROM LWB a TO UPB a DO IF a[i] ~= b[i] THEN return false FI OD;
  TRUE EXIT
  return false: FALSE);

# task starts here #

# these are the only punctuation marks we'll count #
[]CHAR punct = ",'-!";
# and these are their names #
[]STRING punct names = ("comma", "apostrophe", "hyphen", "exclamation");
# here's their offset in the count array #
INT punct offset = ABS "z";

# this reports the character counts the autogram says it has. #
# autogram should be in lower case #
PROC stated counts = (STRING autogram) []INT:
  BEGIN
    []STRING units words = ("one", "two", "three", "four", "five", "six", "seven",
                            "eight", "nine", "ten", "eleven", "twelve", "thirteen",
                            "fourteen", "fifteen", "sixteen", "seventeen",
                            "eighteen", "nineteen");
    []STRING tens words = ("ten", "twenty", "thirty", "forty", "fifty", "sixty",
                           "seventy", "eighty", "ninety");

    [ABS "a" : ABS "z" + UPB punct]INT counts;
    FOR i FROM LWB counts TO UPB counts DO counts[i] := 0 OD;

    []STRING words = split(autogram, " .,-:");

    # we'll advance word by word, trying to detect a numeral and a letter #
    INT idx := 1;
    WHILE idx < UPB words DO
      INT saved idx = idx;
      INT tens = tens words INDEXOF words[idx];
      IF tens > 0 THEN idx +:= 1 FI;
      INT units := units words INDEXOF words[idx];
      IF units = 0 AND words[idx] = "single" THEN units := 1 FI;
      IF units > 0 THEN idx +:= 1 FI;
      INT n = tens * 10 + units;
      # if we read a number (and we aren't out of words), let's see what that
        number is counting #
      IF n > 0 AND idx <= UPB words THEN
        STRING letter := words[idx];
        # let's strip the plural ending, if any #
        INT upb := UPB letter;
        IF upb > 1 AND letter[upb] = "s" THEN upb -:= 1 FI;
        IF upb > 1 AND letter[upb] = "'" THEN upb -:= 1 FI;

        INT slot := -1;  # index in the count array to update #
        # single char: #
        IF upb = 1 THEN
          IF letter[1] >= "a" AND letter[1] <= "z" THEN
            slot := ABS letter[1]
          ELIF INT pos; char in string(letter[1], pos, punct) THEN
            slot := punct offset + pos
          FI
        ELSE # a word, it must be a spelled-out punctuation mark #
          IF INT pos = punct names INDEXOF letter[1:upb]; pos > 0 THEN
            slot := punct offset + pos
          FI
        FI;
        IF slot ~= -1 THEN
          counts[slot] +:= n
        ELSE
          idx := saved idx
        FI
      ELSE
        idx :=saved idx
      FI;
      idx +:= 1
    OD;
    counts
  END;

# counts letters and some punctuation. the string should be in lower case #
PROC actual counts = (STRING autogram) []INT:
  BEGIN
    [ABS "a" : ABS "z" + UPB punct]INT counts;
    FOR i FROM LWB counts TO UPB counts DO counts[i] := 0 OD;
    FOR i TO UPB autogram DO
      CHAR ch = autogram[i];
      IF ch >= "a" AND ch <= "z" THEN counts[ABS ch] +:= 1
      ELIF INT pos; char in string(ch, pos, punct) THEN
        counts[punct offset + pos] +:= 1
      FI
    OD;
    counts
  END;

PROC check = (STRING autogram, BOOL with punct) VOID:
  BEGIN
    print(("  The sentence:", new line, """", autogram, """", new line));
    []INT stated = stated counts(LC autogram);
    []INT actual = actual counts(LC autogram);
    BOOL match = IF with punct THEN stated = actual
                               ELSE stated[:ABS "z"] = actual[:ABS "z"]
                 FI;
    printf(($"  " b("is", "isn't"), " a" b(" punctuation-including", "n") " autogram." ll$,
            match, with punct))
  END;


check("This sentence employs two a's, two c's, two d's, twenty-eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty-five s's, twenty-three t's, six v's, ten w's, two x's, five y's, and one z.", FALSE);

check("This sentence employs two a's, two c's, two d's, twenty eight e's, five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's, nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's, ten w's, two x's, five y's, and one z.", FALSE);

check("Only the fool would take trouble to verify that his sentence was composed of ten a's, three b's, four c's, four d's, forty-six e's, sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's, four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's, forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's, eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens and, last but not least, a single !", TRUE);

check("This pangram contains four as, one b, two cs, one d, thirty es, six fs, five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns, fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us, seven vs, eight ws, two xs, three ys, & one z.", FALSE);

check("This sentence contains one hundred and ninety-seven letters: four a's, one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's, twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's, nineteen t's, six u's, seven v's, four w's, four x's, five y's, and one z.", FALSE);

check("Thirteen e's, five f's, two g's, five h's, eight i's, two l's, three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's, six w's, four x's, two y's.", FALSE);

check("Fifteen e's, seven f's, four g's, six h's, eight i's, four n's, five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's, three x's.", TRUE);

check("Sixteen e's, five f's, three g's, six h's, nine i's, five n's, four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's, four z's.", FALSE)
