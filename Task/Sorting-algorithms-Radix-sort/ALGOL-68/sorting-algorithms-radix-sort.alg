PROC radixsort = (REF []INT array) VOID:
(
    [UPB array]INT zero;
    [UPB array]INT one;
    BITS mask := 16r01;
    INT zero_index  := 0,
        one_index   := 0,
        array_index := 1;

    WHILE ABS(mask) > 0 DO
        WHILE array_index <= UPB array DO
            IF (BIN(array[array_index]) AND mask) = 16r0 THEN
                zero_index +:= 1;
                zero[zero_index] := array[array_index]
            ELSE
                one_index +:= 1;
                one[one_index] := array[array_index]
            FI;
            array_index +:= 1
        OD;

        array_index := 1;
        FOR i FROM 1 TO zero_index DO
            array[array_index] := zero[i];
            array_index +:= 1
        OD;

        FOR i FROM 1 TO one_index DO
            array[array_index] := one[i];
            array_index +:=1
        OD;

        array_index := 1;
        zero_index := one_index := 0;
        mask := mask SHL 1
    OD
);

main:
(
    [10]INT a;
    FOR i FROM 1 TO UPB a DO
        a[i] := ROUND(random*1000)
    OD;

    print(("Before:", a));
    print((newline, newline));
    radixsort(a);
    print(("After: ", a))
)
