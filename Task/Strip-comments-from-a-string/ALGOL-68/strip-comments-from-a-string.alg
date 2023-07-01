#!/usr/local/bin/a68g --script #

PROC trim comment = (STRING line, CHAR marker)STRING:(
  INT index := UPB line+1;
  char in string(marker, index, line);
  FOR i FROM index-1 BY -1 TO LWB line
  WHILE line[i]=" " DO index := i OD;
  line[:index-1]
);

CHAR q = """";

print((
  q, trim comment("apples, pears # and bananas", "#"), q, new line,
  q, trim comment("apples, pears ; and bananas", ";"), q, new line,
  q, trim comment("apples, pears and bananas  ", ";"), q, new line,
  q, trim comment("    ", ";"), q, new line, # blank string #
  q, trim comment("", ";"), q, new line  # empty string #
))

CO Alternatively Algol68g has available "grep"
;STRING re marker := " *#", line := "apples, pears # and bananas";
  INT index := UPB line;
  grep in string(re marker, line, index, NIL);
  print((q, line[:index-1], q, new line))
END CO
