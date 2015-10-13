#--- Swap function ---#
PROC swap = (REF []INT array, INT first, INT second) VOID:
(
    INT temp := array[first];
    array[first] := array[second];
    array[second]:= temp
);

#--- Quick sort 3 arg function ---#
PROC quick = (REF [] INT array, INT first, INT last) VOID:
(
    INT smaller := first + 1,
        larger  := last,
        pivot   := array[first];

    WHILE smaller <= larger DO
        WHILE array[smaller] < pivot   AND   smaller < last DO
            smaller +:= 1
        OD;
        WHILE array[larger]  > pivot   AND   larger > first DO
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
        quick(array, first, larger-1)
    FI;
    IF last > larger +1 THEN
        quick(array, larger+1, last)
    FI
);

#--- Quick sort 1 arg function ---#
PROC quicksort = (REF []INT array) VOID:
(
  IF UPB array > 1 THEN
    quick(array, 1, UPB array)
  FI
);

#***************************************************************#
main:
(
    [10]INT a;
    FOR i FROM 1 TO UPB a DO
        a[i] := ROUND(random*1000)
    OD;

    print(("Before:", a));
    quicksort(a);
    print((newline, newline));
    print(("After: ", a))
)
