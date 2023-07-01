program Knuth;

const
  startIdx = -5;
  max = 11;
type
  tmyData = string[9];
  tmylist = array [startIdx..startIdx+max-1] of tmyData;

procedure InitList(var a: tmylist);
var
  i: integer;
Begin
  for i := Low(a) to High(a) do
    str(i:3,a[i])
end;

procedure shuffleList(var a: tmylist);
var
  i,k : integer;
  tmp: tmyData;
begin
  for i := High(a)-low(a) downto 1 do begin
    k := random(i+1) + low(a);
    tmp := a[i+low(a)]; a[i+low(a)] := a[k]; a[k] := tmp
  end
end;

procedure DisplayList(const a: tmylist);
var
  i : integer;
Begin
  for i := Low(a) to High(a) do
    write(a[i]);
  writeln
end;

{ Test and display }
var
 a: tmylist;
 i: integer;
begin
  randomize;
  InitList(a);
  DisplayList(a);
  writeln;
  For i := 0 to 4 do
  Begin
    shuffleList(a);
    DisplayList(a);
  end;
end.
