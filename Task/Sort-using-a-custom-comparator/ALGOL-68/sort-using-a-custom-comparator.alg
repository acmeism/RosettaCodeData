# define the MODE that will be sorted #
MODE SITEM = STRING;
#--- Swap function ---#
PROC swap = (REF[]SITEM array, INT first, INT second) VOID:
(
    SITEM temp := array[first];
    array[first] := array[second];
    array[second]:= temp
);
#--- Quick sort partition arg function with custom comparision function ---#
PROC quick = (REF[]SITEM array, INT first, INT last, PROC(SITEM,SITEM)INT compare) VOID:
(
    INT   smaller := first + 1,
          larger  := last;
    SITEM pivot   := array[first];
    WHILE smaller <= larger DO
        WHILE compare(array[smaller], pivot) < 0 AND smaller < last DO
            smaller +:= 1
        OD;
        WHILE compare( array[larger], pivot) > 0 AND larger > first DO
            larger  -:= 1
        OD;
        IF smaller < larger THEN
            swap(array, smaller, larger);
            smaller +:= 1;
            larger  -:= 1
        ELSE
            smaller +:= 1
        FI
    OD;
    swap(array, first, larger);
    IF first < larger-1 THEN
        quick(array, first, larger-1, compare)
    FI;
    IF last > larger +1 THEN
        quick(array, larger+1, last, compare)
    FI
);
#--- Quick sort array function with custom comparison function ---#
PROC quicksort = (REF[]SITEM array, PROC(SITEM,SITEM)INT compare) VOID:
(
  IF UPB array > LWB array THEN
    quick(array, LWB array, UPB array, compare)
  FI
);
#***************************************************************#
main:
(
    OP LENGTH  = (STRING a)INT: ( UPB a + 1 ) - LWB a;
    OP TOLOWER = (STRING a)STRING:
       BEGIN
           STRING result := a;
           FOR i FROM LWB result TO UPB result DO
               CHAR c = a[i];
               IF c >= "A" AND c <= "Z" THEN result[i] := REPR ( ( ABS c - ABS "A" ) + ABS "a" ) FI
           OD;
           result
       END # TOLOWER # ;
    # custom comparison, descending sort on length #
    # if lengths are equal, sort lexicographically #
    PROC compare = (SITEM a, b)INT:
         IF   INT a length = LENGTH a;
              INT b length = LENGTH b;
              a length < b length
         THEN
             # a is shorter than b #  1
         ELIF a length > b length
         THEN
             # a is longer than b  # -1
         ELIF STRING lower a = TOLOWER a;
              STRING lower b = TOLOWER b;
              lower a < lower b
         THEN
              # lowercase a is before lowercase b # -1
         ELIF lower a > lower b
         THEN
              # lowercase a is after lowercase b  #  1
         ELIF a > b
         THEN
             # a and b are equal ignoring case,        #
             # but a is after b considering case       #  1
         ELIF a < b
         THEN
             # a and b are equal ignoring case,        #
             # but a is before b considering case      # -1
         ELSE
             # the strings are equal                   #  0
         FI # compare # ;
    []SITEM orig = ("Here", "are", "some", "sample", "strings", "to", "be", "sorted");
    [LWB orig : UPB orig]SITEM a := orig;
    print(("Before:"));FOR i FROM LWB a TO UPB a DO print((" ",a[i])) OD; print((newline));
    quicksort(a, compare);
    print(("After :"));FOR i FROM LWB a TO UPB a DO print((" ",a[i])) OD; print((newline))
)
