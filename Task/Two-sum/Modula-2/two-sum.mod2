MODULE TwoSum;
FROM FormatString IMPORT FormatString;
FROM Terminal IMPORT WriteString,ReadChar;

TYPE
    Pair = RECORD
        f,s : INTEGER;
    END;

PROCEDURE TwoSum(CONST arr : ARRAY OF INTEGER; CONST sum : INTEGER) : Pair;
VAR i,j,temp : INTEGER;
BEGIN
    i := 0;
    j := HIGH(arr)-1;

    WHILE i<=j DO
        temp := arr[i] + arr[j];
        IF temp=sum THEN
            RETURN Pair{i,j};
        END;
        IF temp<sum THEN
            INC(i);
        ELSE
            DEC(j);
        END;
    END;

    RETURN Pair{-1,-1};
END TwoSum;

VAR
    buf : ARRAY[0..63] OF CHAR;
    arr : ARRAY[0..4] OF INTEGER;
    res : Pair;
BEGIN
    arr[0]:=0;
    arr[1]:=2;
    arr[2]:=11;
    arr[3]:=19;
    arr[4]:=90;

    res := TwoSum(arr, 21);
    FormatString("[%i, %i]\n", buf, res.f, res.s);
    WriteString(buf);
    ReadChar;
END TwoSum.
