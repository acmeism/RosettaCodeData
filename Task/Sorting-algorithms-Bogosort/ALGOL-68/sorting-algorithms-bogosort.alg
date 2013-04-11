MODE TYPE = INT;

PROC random shuffle = (REF[]TYPE l)VOID: (
    INT range = UPB l - LWB l + 1;
    FOR index FROM LWB l TO UPB l DO
        TYPE tmp := l[index];
        INT other := ENTIER (LWB l + random * range);
        l[index] := l[other];
        l[other] := tmp
    OD
);

PROC in order = (REF[]TYPE l)BOOL: (
    IF LWB l >= UPB l THEN
        TRUE
    ELSE
        TYPE last := l[LWB l];
        FOR index FROM LWB l + 1 TO UPB l DO
            IF l[index] < last THEN
                GO TO return false
            FI;
            last := l[index]
        OD;
        TRUE EXIT
        return false: FALSE
    FI
);

PROC bogo sort = (REF[]TYPE l)REF[]TYPE: (
    WHILE NOT in order(l) DO
        random shuffle(l)
    OD;
    l
);

[6]TYPE sample := (61, 52, 63, 94, 46, 18);
print((bogo sort(sample), new line))
