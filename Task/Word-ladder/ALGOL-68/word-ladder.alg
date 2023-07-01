# quick implementation of a stack of INT.
  real program starts after it.
#
MODE STACK = STRUCT (INT top, FLEX[1:0]INT data, INT increment);

PROC makestack = (INT increment)STACK: (1, (), increment);

PROC pop = (REF STACK s)INT: ( top OF s -:= 1; (data OF s)[top OF s] );

PROC push = (REF STACK s, INT n)VOID:
  BEGIN
    IF top OF s > UPB data OF s THEN
      [ UPB data OF s + increment OF s ]INT tmp;
      tmp[1 : UPB data OF s] := data OF s;
      data OF s := tmp
    FI;
    (data OF s)[top OF s] := n;
    top OF s +:= 1
  END;

PROC empty = (REF STACK s)BOOL: top OF s <= 1;

PROC contents = (REF STACK s)[]INT: (data OF s)[:top OF s - 1];

# start solution #

[]STRING words = BEGIN     # load dictionary file into array #
                   FILE f;
                   BOOL eof := FALSE;
                   open(f, "unixdict.txt", stand in channel);
                   on logical file end(f, (REF FILE f)BOOL: eof := TRUE);
                   INT idx := 1;
                   FLEX [1:0] STRING words;
                   STRING word;
                   WHILE NOT eof DO
                     get(f, (word, newline));
                     IF idx > UPB words THEN
                       HEAP [1 : UPB words + 10000]STRING tmp;
                       tmp[1 : UPB words] := words;
                       words := tmp
                     FI;
                     words[idx] := word;
                     idx +:= 1
                   OD;
                   words[1:idx-1]
                 END;

INT nwords = UPB words;

INT max word length = (INT mwl := 0;
                       FOR i TO UPB words DO
                         IF mwl < UPB words[i] THEN mwl := UPB words[i] FI
                       OD;
                       mwl);

[nwords]FLEX[0]INT neighbors;

[max word length]BOOL precalculated by length;

FOR i TO UPB precalculated by length DO precalculated by length[i] := FALSE OD;

# precalculating neighbours takes time, but not doing it is even slower... #
PROC precalculate neighbors = (INT word length)VOID:
  BEGIN
    [nwords]REF STACK stacks;
    FOR i TO UPB stacks DO stacks[i] := NIL OD;
    FOR i TO UPB words DO
      IF UPB words[i] = word length THEN
        IF REF STACK(stacks[i]) :=: NIL THEN stacks[i] := HEAP STACK := makestack(10) FI;
        FOR j FROM i + 1 TO UPB words DO
          IF UPB words[j] = word length THEN
            IF neighboring(words[i], words[j]) THEN
              push(stacks[i], j);
              IF REF STACK(stacks[j]) :=: NIL THEN stacks[j] := HEAP STACK := makestack(10) FI;
              push(stacks[j], i)
            FI
          FI
        OD
      FI
    OD;
    FOR i TO UPB neighbors DO
      IF REF STACK(stacks[i]) :/=: NIL THEN
        neighbors[i] := contents(stacks[i])
      FI
    OD;
    precalculated by length [word length] := TRUE
  END;

PROC neighboring = (STRING a, b)BOOL:      # do a & b differ in just 1 char? #
  BEGIN
    INT diff := 0;
    FOR i TO UPB a DO IF a[i] /= b[i] THEN diff +:= 1 FI OD;
    diff = 1
  END;

PROC word ladder = (STRING from, STRING to)[]STRING:
  BEGIN
    IF UPB from /= UPB to THEN fail FI;
    INT word length = UPB from;
    IF word length < 1 OR word length > max word length THEN fail FI;
    IF from = to THEN fail FI;
    INT start := 0;
    INT destination := 0;
    FOR i TO UPB words DO
      IF UPB words[i] = word length THEN
        IF words[i] = from THEN start := i
        ELIF words[i] = to THEN destination := i
        FI
      FI
    OD;
    IF destination = 0 OR start = 0 THEN fail FI;
    IF NOT precalculated by length [word length] THEN
      precalculate neighbors(word length)
    FI;
    STACK stack := makestack(1000);
    [nwords]INT distance;
    [nwords]INT previous;
    FOR i TO nwords DO distance[i] := nwords+1; previous[i] := 0 OD;
    INT shortest := nwords+1;
    distance[start] := 0;
    push(stack, start);
    WHILE NOT empty(stack)
    DO
      INT curr := pop(stack);
      INT dist := distance[curr];
      IF dist < shortest - 1 THEN
        # find neighbors and add them to the stack #
        FOR i FROM UPB neighbors[curr] BY -1 TO 1 DO
          INT n = neighbors[curr][i];
          IF distance[n] > dist + 1 THEN
            distance[n] := dist + 1;
            previous[n] := curr;
            IF n = destination THEN
              shortest := dist + 1
            ELSE
              push(stack, n)
            FI
          FI
        OD;
        IF curr = destination THEN shortest := dist FI
      FI
    OD;
    INT length = distance[destination] + 1;
    IF length > nwords THEN fail FI;
    [length]STRING result;
    INT curr := destination;
    FOR i FROM length BY -1 TO 1
    DO
      result[i] := words[curr];
      curr := previous[curr]
    OD;
    result EXIT
    fail: LOC [0] STRING
  END;

[][]STRING pairs = (("boy", "man"), ("bed", "cot"),
                    ("old", "new"), ("dry", "wet"),

                    ("girl", "lady"), ("john", "jane"),
                    ("lead", "gold"), ("poor", "rich"),
                    ("lamb", "stew"), ("kick", "goal"),
                    ("cold", "warm"), ("nude", "clad"),

                    ("child", "adult"), ("white", "black"),
                    ("bread", "toast"), ("lager", "stout"),
                    ("bride", "groom"), ("table", "chair"),

                    ("bubble", "tickle"));

FOR i TO UPB pairs
DO
  STRING from = pairs[i][1], to = pairs[i][2];
  []STRING ladder = word ladder(from, to);
  IF UPB ladder = 0
  THEN print(("No solution for """ + from + """ -> """ + to + """", newline))
  ELSE FOR j TO UPB ladder DO print(((j > 1 | "->" | ""), ladder[j])) OD;
       print(newline)
  FI
OD
