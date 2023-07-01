MODE STRINGLIST = STRUCT(STRING value, REF STRINGLIST next);

STRINGLIST list := ("Big",
  LOC STRINGLIST := ("fjords",
    LOC STRINGLIST := ("vex",
      LOC STRINGLIST := ("quick",
        LOC STRINGLIST := ("waltz",
          LOC STRINGLIST := ("nymph",NIL))))));

REF STRINGLIST node := list;
WHILE node ISNT REF STRINGLIST(NIL) DO
  print((value OF node, space));
  node := next OF node
OD;
print(newline)
