# using code from the Singly-linked-list Element Traversal task #

MODE STRINGLIST = STRUCT(STRING value, REF STRINGLIST next);

# removes the specified element from the list, modifying list if necessary #
PRIO REMOVE = 1;
OP   REMOVE = ( REF STRINGLIST list, REF STRINGLIST element )REF STRINGLIST:
     IF element ISNT REF STRINGLIST(NIL) THEN
         # have an element to remove #
         IF REF STRINGLIST(list) IS REF STRINGLIST(element) THEN
             # remove the head #
             list := next OF list
         ELSE
             # not removing the head element #
             REF STRINGLIST list pos := list;
             WHILE IF   REF STRINGLIST(list pos) IS REF STRINGLIST(NIL) THEN FALSE
                   ELSE REF STRINGLIST(next OF list pos) ISNT REF STRINGLIST(element)
                   FI
             DO
                 list pos := next OF list pos
             OD;
             IF REF STRINGLIST(list pos) ISNT REF STRINGLIST(NIL) THEN
                 # found the element #
                 next OF list pos := next OF next OF list pos
             FI
         FI;
         list
     ELSE
         list
     FI # REMOVE # ;

BEGIN # tests #
    STRINGLIST list := ("Big",
       LOC STRINGLIST := ("fjords",
          LOC STRINGLIST := ("vex",
             LOC STRINGLIST := ("quick",
                LOC STRINGLIST := ("waltz",
                   LOC STRINGLIST := ("nymph",NIL))))));

    ( list REMOVE next OF next OF list ) REMOVE list;
    REF STRINGLIST node := list;
    WHILE node ISNT REF STRINGLIST(NIL) DO
       print((value OF node, space));
       node := next OF node
    OD;
    print(newline)
END
