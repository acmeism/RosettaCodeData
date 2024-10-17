BEGIN
MODE ELEMENT = STRING;

# Iterative: #
PROC iterative binary search = ([]ELEMENT hay stack, ELEMENT needle)INT: (
    INT out,
        low := LWB hay stack,
        high := UPB hay stack;
    WHILE low < high DO
        INT mid := (low+high) OVER 2;
        IF hay stack[mid] > needle THEN high := mid-1
        ELIF hay stack[mid] < needle THEN low := mid+1
        ELSE out:= mid; stop iteration FI
    OD;
        low EXIT
    stop iteration:
        out
);
# Recursive: #
PROC recursive binary search = ([]ELEMENT hay stack, ELEMENT needle)INT: (
    IF LWB hay stack > UPB hay stack THEN
        LWB hay stack
    ELIF LWB hay stack = UPB hay stack THEN
        IF hay stack[LWB hay stack] = needle THEN LWB hay stack
        ELSE LWB hay stack FI
    ELSE
        INT mid := (LWB hay stack+UPB hay stack) OVER 2;
        IF hay stack[mid] > needle THEN recursive binary search(hay stack[:mid-1], needle)
        ELIF hay stack[mid] < needle THEN mid + recursive binary search(hay stack[mid+1:], needle)
        ELSE mid FI
   FI
);
PROC test search = (PROC([]ELEMENT, ELEMENT)INT search, []ELEMENT hay stack, []ELEMENT test cases)VOID:
     FOR case TO UPB test cases DO
        ELEMENT needle = test cases[case];
        INT index = search(hay stack, needle);
        BOOL found = ( index <= 0 | FALSE | hay stack[index]=needle);
        print(("""", needle, """ ", (found|"FOUND at"|"near"), " index ", whole(index, 0), newline))
     OD;

 BEGIN  # Test cases: #
  []ELEMENT hay stack = ("AA","Maestro","Mario","Master","Mattress","Mister","Mistress","ZZ")
          , test cases = ("A","Master","Monk","ZZZ")
          ;
  test search(iterative binary search, hay stack, test cases);
  test search(recursive binary search, hay stack, test cases)
 END
END
