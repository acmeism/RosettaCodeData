PROC sierpinski = (INT n)[]STRING: (
    FLEX[0]STRING d := "*";
    FOR i TO n DO
        [UPB d * 2]STRING next;
        STRING sp := " " * (2 ** (i-1));
        FOR x TO UPB d DO
          STRING dx = d[x];
          next[x] := sp+dx+sp;
          next[UPB d+x] := dx+" "+dx
        OD;
        d := next
    OD;
    d
);

printf(($gl$,sierpinski(4)))
