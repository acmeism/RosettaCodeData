[1:10]PROC(BOOL)INT squares;

FOR i FROM 1 TO 10 DO
        HEAP INT captured i := i;
        squares[i] := ((REF INT by ref i, INT by val i,BOOL b)INT:(INT i = by ref i; (b|by ref i := 0); by val i*i))
                (captured i, captured i,)
OD;

FOR i FROM 1 TO 8 DO print(squares[i](i MOD 2 = 0)) OD;
print(new line);
FOR i FROM 1 TO 10 DO print(squares[i](FALSE)) OD
