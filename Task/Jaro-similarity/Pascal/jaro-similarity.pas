program Jaro_distance;

uses SysUtils, Math;

//converted from C source by /u/bleuge
function ssJaroWinkler(s1, s2: string): double;
var
  l1, l2, match_distance, matches, i, k, trans: integer;
  bs1, bs2: array[1..255] of boolean; //used to avoid getmem, max string length is 255
begin
  l1 := length(s1);
  l2 := length(s2);
  fillchar(bs1, sizeof(bs1), 0); //set booleans to false
  fillchar(bs2, sizeof(bs2), 0);
  if l1 = 0 then
    if l2 = 0 then
      exit(1)
    else
      exit(0);
  match_distance := (max(l1, l2) div 2) - 1;
  matches := 0;
  trans := 0;
  for i := 1 to l1 do
  begin
    for k := max(1, i - match_distance) to min(i + match_distance, l2) do
    begin
      if bs2[k] then
        continue;
      if s1[i] <> s2[k] then
        continue;
      bs1[i] := true;
      bs2[k] := true;
      inc(matches);
      break;
    end;
  end;
  if matches = 0 then
    exit(0);
  k := 1;
  for i := 1 to l1 do
  begin
    if (bs1[i] = false) then
      continue;
    while (bs2[k] = false) do
      inc(k);
    if s1[i] <> s2[k] then
      inc(trans);
    inc(k);
  end;
  trans := trans div 2;
  result := ((matches / l1) + (matches / l2) + ((matches - trans) / matches)) / 3;
end;

begin
//test
  writeln(formatfloat('0.######', ssJaroWinkler('DWAYNE', 'DUANE')));
  writeln(formatfloat('0.######', ssJaroWinkler('MARTHA', 'MARHTA')));
  writeln(formatfloat('0.######', ssJaroWinkler('DIXON', 'DICKSONX')));
  writeln(formatfloat('0.######', ssJaroWinkler('JELLYFISH', 'SMELLYFISH')));
  {$IFNDEF LINUX}readln;{$ENDIF}
end.
