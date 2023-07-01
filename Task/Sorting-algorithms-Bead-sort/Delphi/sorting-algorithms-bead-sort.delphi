program BeadSortTest;

{$APPTYPE CONSOLE}

uses
  SysUtils;

procedure BeadSort(var a : array of integer);
var
  i, j, max, sum : integer;
  beads : array of array of integer;
begin
  max := a[Low(a)];
  for i := Low(a) + 1 to High(a) do
    if a[i] > max then
      max := a[i];

  SetLength(beads, High(a) - Low(a) + 1, max);

  // mark the beads

  for i := Low(a) to High(a) do
    for j := 0 to a[i] - 1 do
      beads[i, j] := 1;

  for j := 0 to max - 1 do
  begin
    // count how many beads are on each post
    sum := 0;
    for i := Low(a) to High(a) do
    begin
      sum := sum + beads[i, j];
      beads[i, j] := 0;
    end;
    //mark bottom sum beads
    for i := High(a) + 1 - sum to High(a) do
      beads[i, j] := 1;
  end;

  for i := Low(a) to High(a) do
  begin
    j := 0;
    while (j < max) and (beads[i, j] <> 0) do
      inc(j);
    a[i] := j;
  end;

  SetLength(beads, 0, 0);
end;

const
  N = 8;
var
  i : integer;
  x : array[1..N] of integer = (5, 3, 1, 7, 4, 1, 1, 20);
begin
  for i := 1 to N do
    writeln(Format('x[%d] = %d', [i, x[i]]));

  BeadSort(x);

  for i := 1 to N do
    writeln(Format('x[%d] = %d', [i, x[i]]));

  readln;
end.
