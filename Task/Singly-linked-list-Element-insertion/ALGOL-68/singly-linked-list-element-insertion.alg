MODE STRINGLIST = STRUCT(STRING value, REF STRINGLIST next);

STRINGLIST list := ("Big",
  LOC STRINGLIST := ("fjords",
    LOC STRINGLIST := ("vex",
      LOC STRINGLIST := ("quick",
        LOC STRINGLIST := ("waltz",
          LOC STRINGLIST := ("nymph",NIL))))));

PROC insert = (REF STRINGLIST list, node)VOID: (
  next OF node := next OF list;
  next OF list := node
);

STRINGLIST very := ("VERY", NIL);

# EXAMPLE OF INSERTION #
insert(next OF next OF list, very );

REF STRINGLIST node := list;
WHILE REF STRINGLIST(node) ISNT NIL DO
  print((value OF node, space));
  node := next OF node
OD;
print((newline))
