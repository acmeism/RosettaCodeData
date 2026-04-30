PROC ordered = (STRING s)BOOL:
  BEGIN
    FOR i TO UPB s - 1 DO IF s[i] > s[i+1] THEN return false FI OD;
    TRUE EXIT
    return false: FALSE
  END;

IF FILE input file;
   STRING file name = "unixdict.txt";
   open(input file, file name, stand in channel) /= 0
THEN
  print(("Unable to open file """ + file name + """", newline))
ELSE
  BOOL at eof := FALSE;
  on logical file end (input file, (REF FILE f)BOOL: at eof := TRUE);

  FLEX [1:0] STRING words;
  INT idx := 1;
  INT max length := 0;

  WHILE NOT at eof
  DO
    STRING word;
    get(input file, (word, newline));
    IF UPB word >= max length
    THEN IF ordered(word)
         THEN
           max length := UPB word;
           IF idx > UPB words
           THEN
             [1 : UPB words + 20] STRING tmp;
             tmp[1 : UPB words] := words;
             words := tmp
           FI;
           words[idx] := word;
           idx +:= 1
         FI
    FI
  OD;
  print(("Maximum length of ordered words: ", whole(max length, -4), newline));
  FOR i TO idx-1
  DO
    IF UPB words[i] = max length THEN print((words[i], newline)) FI
  OD
FI
