#--- Swap function ---#
PROC swap = (REF []INT array, INT first, INT second) VOID:
(
    INT temp := array[first];
    array[first] := array[second];
    array[second]:= temp
);

#--- Heap sort Move Down ---#
PROC heapmove = (REF []INT array, INT i, INT last) VOID:
(
    INT index := i;
    INT larger := (index*2);

    WHILE larger <= last DO
        IF larger < last THEN IF array[larger] < array[larger+1] THEN
            larger +:= 1
        FI FI;
        IF array[index] < array[larger] THEN
            swap(array, index, larger)
        FI;
        index := larger;
        larger := (index*2)
    OD
);

#--- Heap sort ---#
PROC heapsort = (REF []INT array) VOID:
(
    FOR i FROM ENTIER((UPB array) / 2) BY -1 WHILE
        heapmove(array, i, UPB array);
    i > 1 DO SKIP OD;

    FOR i FROM UPB array BY -1 WHILE
        swap(array, 1, i);
        heapmove(array, 1, i-1);
    i > 1 DO SKIP OD
);
#***************************************************************#
main:
(
    [10]INT a;
    FOR i FROM 1 TO UPB a DO
        a[i] := ROUND(random*100)
    OD;

    print(("Before:", a));
    print((newline, newline));
    heapsort(a);
    print(("After: ", a))

)
