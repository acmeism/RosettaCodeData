INT n = 15;
[ 0 : n + 1 ]INT t;
t[0] := 0;
t[1] := 1;
FOR i TO n DO
    FOR j FROM i   BY -1 TO 2 DO t[j] := t[j] + t[j-1] OD;
    t[i+1] := t[i];
    FOR j FROM i+1 BY -1 TO 2 DO t[j] := t[j] + t[j-1] OD;
    print( ( whole( t[i+1] - t[i], 0 ), " " ) )
OD
