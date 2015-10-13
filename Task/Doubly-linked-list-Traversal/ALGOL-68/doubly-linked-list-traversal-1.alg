# Node struct - contains next and prev NODE pointers and DATA #
MODE NODE = STRUCT(
    DATA data,
    REF NODE prev,
    REF NODE next
    );

# List structure - contains head and tail NODE pointers #
MODE LIST = STRUCT(
    REF NODE head,
    REF NODE tail
    );

# --- PREPEND - Adds a node to the beginning of the list ---#
PRIO PREPEND = 1;
OP   PREPEND = (REF LIST list, DATA data) VOID:
(    		
    HEAP NODE n := (data, NIL, NIL);
    IF head OF list IS REF NODE(NIL) THEN
        head OF list := tail OF list := n
    ELSE
        next OF n := head OF list;
        prev OF head OF list := head OF list := n
    FI
);
#--- APPEND - Adds a node to the end of the list ---#
PRIO APPEND = 1;
OP   APPEND = (REF LIST list, DATA data) VOID:
(
    HEAP NODE n := (data, NIL, NIL);
    IF head OF list IS REF NODE(NIL) THEN
        head OF list := tail OF list := n
    ELSE
        prev OF n := tail OF list;
        next OF tail OF list := tail OF list := n
    FI
);

#--- REMOVE_FIRST - removes & returns node at end of the list ---#
PRIO REMOVE_FIRST = 1;
OP   REMOVE_FIRST = (REF LIST list) DATA:
(
    IF head OF list ISNT REF NODE(NIL) THEN
        DATA d := data OF head OF list;
        prev OF next OF head OF list := NIL;
        head OF list := next OF head OF list;
        d # return d #
    FI
);
#--- REMOVE_LAST: removes & returns node at front of list ---   #
PRIO REMOVE_LAST = 1;
OP   REMOVE_LAST = (REF LIST list) DATA:
(
    IF head OF list ISNT REF NODE(NIL) THEN
        DATA d := data OF tail OF list;
        next OF prev OF tail OF list := NIL;
        tail OF list := prev OF tail OF list;
        d # return d #
    FI
);
#--- PURGE - removes all elements from the list ---#
PRIO PURGE = 2;
OP   PURGE = (REF LIST list) VOID:
(
    head OF list := tail OF list := NIL
);

#--- returns the data at the end of the list ---#
PRIO LAST_IN = 2;
OP LAST_IN = (REF LIST list) DATA: (
    IF head OF list ISNT REF NODE(NIL) THEN
        data OF tail OF list
    FI
);

#--- returns the data at the front of the list ---#
PRIO FIRST_IN  = 2;
OP FIRST_IN = (REF LIST list) DATA: (
    IF head OF list ISNT REF NODE(NIL) THEN
        data OF head OF list
    FI
);

#--- Traverses through the list forwards ---#
PROC forward traversal = (LIST list) VOID:
(
    REF NODE travel := head OF list;
    WHILE travel ISNT REF NODE(NIL) DO
        list visit(data OF travel);
        travel := next OF travel
    OD
);

#--- Traverses through the list backwards ---#
PROC backward traversal = (LIST list) VOID:
(
    REF NODE travel := tail OF list;
    WHILE travel ISNT REF NODE(NIL) DO
        list visit(data OF travel);
        travel := prev OF travel
    OD
)
