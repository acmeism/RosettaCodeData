var
  bsdseed, msseed: int64;

function bsdrand: cardinal;
begin
  bsdseed := (1_103_515_245 * bsdseed + 12_345) and $7fffffff;
  bsdrand := bsdseed;
end;

function msrand: cardinal;
begin
  msseed := (214_013 * msseed + 2_531_011) and $ffffffff;
  msrand := msseed shr 16;
end;

begin
  writeln('      BSD            MS');
  bsdseed := 0;
  msseed := 0;
  loop 10 do writeln(bsdrand:12, msrand:12);
end.
