MODE TYPE = CHAR;

PROC in place shell sort = (REF[]TYPE seq)REF[]TYPE:(
    INT inc := ( UPB seq + LWB seq + 1 ) OVER 2;
    WHILE inc NE 0 DO
        FOR index FROM LWB seq TO UPB seq DO
            INT i := index;
            TYPE el = seq[i];
            WHILE ( i  - LWB seq >= inc | seq[i - inc] > el | FALSE ) DO
                seq[i] := seq[i - inc];
                i -:= inc
            OD;
            seq[i] := el
        OD;
        inc := IF inc = 2 THEN 1 ELSE ENTIER(inc * 5 / 11) FI
    OD;
    seq
);

PROC shell sort = ([]TYPE seq)[]TYPE:
  in place shell sort(LOC[LWB seq: UPB seq]TYPE:=seq);

[]TYPE char array data = "big fjords vex quick waltz nymph";
print((shell sort(char array data), new line))
