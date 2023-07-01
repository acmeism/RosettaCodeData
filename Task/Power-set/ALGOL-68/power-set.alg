MODE MEMBER = INT;

PROC power set = ([]MEMBER s)[][]MEMBER:(
  [2**UPB s]FLEX[1:0]MEMBER r;
  INT upb r := 0;
  r[upb r +:= 1] := []MEMBER(());
  FOR i TO UPB s DO
    MEMBER e = s[i];
    FOR j TO upb r DO
      [UPB r[j] + 1]MEMBER x;
      x[:UPB x-1] := r[j];
      x[UPB x] := e; # append to the end of x #
      r[upb r +:= 1] := x # append to end of r #
    OD
  OD;
  r[upb r] := s;
  r
);
# Example: #
test:(
  [][]MEMBER set = power set((1, 2, 4));
  FOR member TO UPB set DO
    INT upb = UPB set[member];
    FORMAT repr set = $"("f( upb=0 | $$ | $n(upb-1)(d", ")d$ )");"$;
    printf(($"set["d"] = "$,member, repr set, set[member],$l$))
  OD
)
