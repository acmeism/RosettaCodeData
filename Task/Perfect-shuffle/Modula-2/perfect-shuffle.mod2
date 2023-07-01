MODULE PerfectShuffle;
FROM FormatString IMPORT FormatString;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM SYSTEM IMPORT ADDRESS,TSIZE;
FROM Terminal IMPORT WriteString,WriteLn,ReadChar;

PROCEDURE WriteCard(c : CARDINAL);
VAR buf : ARRAY[0..15] OF CHAR;
BEGIN
    FormatString("%c", buf, c);
    WriteString(buf)
END WriteCard;

PROCEDURE Init(VAR arr : ARRAY OF INTEGER);
VAR i : CARDINAL;
BEGIN
    FOR i:=0 TO HIGH(arr) DO
        arr[i] := i + 1
    END
END Init;

PROCEDURE PerfectShuffle(VAR arr : ARRAY OF INTEGER);
    PROCEDURE Inner(ti : CARDINAL);
    VAR
        tv : INTEGER;
        tp,tn,n : CARDINAL;
    BEGIN
        n := HIGH(arr);
        tn := ti;
        tv := arr[ti];
        REPEAT
            tp := tn;
            IF tp MOD 2 = 0 THEN
                tn := tp / 2
            ELSE
                tn := (n+1)/2+tp/2
            END;
            arr[tp] := arr[tn];
        UNTIL tn = ti;
        arr[tp] := tv
    END Inner;
VAR
    done : BOOLEAN;
    i,c : CARDINAL;
BEGIN
    c := 0;
    Init(arr);

    REPEAT
        i := 1;
        WHILE i <= (HIGH(arr)/2) DO
            Inner(i);
            INC(i,2)
        END;
        INC(c);

        done := TRUE;
        FOR i:=0 TO HIGH(arr) DO
            IF arr[i] # INT(i+1) THEN
                done := FALSE;
                BREAK
            END
        END
    UNTIL done;

    WriteCard(HIGH(arr)+1);
    WriteString(": ");
    WriteCard(c);
    WriteLn
END PerfectShuffle;

(* Main *)
VAR
        v8 : ARRAY[1..8] OF INTEGER;
       v24 : ARRAY[1..24] OF INTEGER;
       v52 : ARRAY[1..52] OF INTEGER;
      v100 : ARRAY[1..100] OF INTEGER;
     v1020 : ARRAY[1..1020] OF INTEGER;
     v1024 : ARRAY[1..1024] OF INTEGER;
    v10000 : ARRAY[1..10000] OF INTEGER;
BEGIN
    PerfectShuffle(v8);
    PerfectShuffle(v24);
    PerfectShuffle(v52);
    PerfectShuffle(v100);
    PerfectShuffle(v1020);
    PerfectShuffle(v1024);
    PerfectShuffle(v10000);

    ReadChar
END PerfectShuffle.
