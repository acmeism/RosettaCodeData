UNIONX data := 6.6;
CASE data IN
   (INT i): printf(($"r: "gl$,i)),
   (REAL r): printf(($"r: "gl$,r)),
   (STRUCT(REAL r, INT i) s): printf(($"r&i: "2(g)l$,s)),
   (STRUCT([]REAL r) s): printf(($"r: "n(UPB r OF s)(g)l$,s))
OUT
  printf($"Other cases"l$)
ESAC;
