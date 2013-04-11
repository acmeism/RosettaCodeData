MODE FIELD = REAL; # FIELD can be REAL, LONG REAL etc, or COMPL, FRAC etc #
MODE VEC = [0]FIELD;
MODE MAT = [0,0]FIELD;

PROC to reduced row echelon form = (REF MAT m)VOID: (
    INT lead col := 2 LWB m;

    FOR this row FROM LWB m TO UPB m DO
        IF lead col > 2 UPB m THEN return FI;
        INT other row := this row;
        WHILE m[other row,lead col] = 0 DO
            other row +:= 1;
            IF other row > UPB m THEN
                other row := this row;
                lead col +:= 1;
                IF lead col > 2 UPB m THEN return FI
            FI
        OD;
        IF this row /= other row THEN
            VEC swap = m[this row,lead col:];
            m[this row,lead col:] := m[other row,lead col:];
            m[other row,lead col:] := swap
        FI;
        FIELD scale = 1/m[this row,lead col];
        IF scale /= 1 THEN
            m[this row,lead col] := 1;
            FOR col FROM lead col+1 TO 2 UPB m DO m[this row,col] *:= scale OD
        FI;
        FOR other row FROM LWB m TO UPB m DO
            IF this row /= other row THEN
                REAL scale = m[other row,lead col];
                m[other row,lead col]:=0;
                FOR col FROM lead col+1 TO 2 UPB m DO m[other row,col] -:= scale*m[this row,col] OD
            FI
        OD;
        lead col +:= 1
    OD;
    return: EMPTY
);

[3,4]FIELD mat := (
   ( 1, 2, -1, -4),
   ( 2, 3, -1, -11),
   (-2, 0, -3, 22)
);

to reduced row echelon form( mat );

FORMAT
  real repr = $g(-7,4)$,
  vec repr = $"("n(2 UPB mat-1)(f(real repr)", ")f(real repr)")"$,
  mat repr = $"("n(1 UPB mat-1)(f(vec repr)", "lx)f(vec repr)")"$;

printf((mat repr, mat, $l$))
