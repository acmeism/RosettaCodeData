BEGIN
  MODE STRINGLIST = STRUCT(STRING value, REF STRINGLIST next);

  # construct a STRINGLIST with a few elements #
  STRINGLIST list := ("Big",
    LOC STRINGLIST := ("fjords",
      LOC STRINGLIST := ("vex",
        LOC STRINGLIST := ("quick",
          LOC STRINGLIST := ("waltz",
            LOC STRINGLIST := ("nymph",NIL))))));

  # print the list and build the reverse list #
  REF STRINGLIST node    := list;
  REF STRINGLIST reverse := REF STRINGLIST(NIL);
  WHILE node ISNT REF STRINGLIST(NIL) DO
    reverse := HEAP STRINGLIST
            := STRINGLIST( value OF node, reverse );
    print((value OF node, space));
    node := next OF node
  OD;
  print(newline);
  # print the reverse list #
  node := reverse;
  WHILE node ISNT REF STRINGLIST(NIL) DO
    print((value OF node, space));
    node := next OF node
  OD;
  print(newline)
END
