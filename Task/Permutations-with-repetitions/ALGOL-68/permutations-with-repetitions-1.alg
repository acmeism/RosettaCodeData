# -*- coding: utf-8 -*- #

MODE PERMELEMLIST = FLEX[0]PERMELEM;
MODE PERMELEMLISTYIELD = PROC(PERMELEMLIST)VOID;

PROC perm gen elemlist = (FLEX[]PERMELEMLIST master, PERMELEMLISTYIELD yield)VOID:(
  [LWB master:UPB master]INT counter;
  [LWB master:UPB master]PERMELEM out;
  FOR i FROM LWB counter TO UPB counter DO
    INT c = counter[i] := LWB master[i];
    out[i] := master[i][c]
  OD;
  yield(out);
  WHILE TRUE DO
    INT next i := LWB counter;
    counter[next i] +:= 1;
    FOR i FROM LWB counter TO UPB counter WHILE counter[i]>UPB master[i] DO
      INT c = counter[i] := LWB master[i];
      out[i] := master[i][c];
      next i := i + 1;
      IF next i > UPB counter THEN done FI;
      counter[next i] +:= 1
    OD;
    INT c = counter[next i];
    out[next i] := master[next i][c];
    yield(out)
  OD;
  done: SKIP
);

SKIP
