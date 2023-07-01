Program EquilibriumIndexDemo(output);
{$IFDEF FPC}{$Mode delphi}{$ENDIF}
type
  tEquiData = shortInt;//Int64;extended ,double
  tnumList = array of tEquiData;
  tresList = array of LongInt;
const
  cNumbers: array [11..17] of tEquiData = (-7, 1, 5, 2, -4, 3, 0);

function ArraySum(const list: tnumList):tEquiData;
var
  i: integer;
begin
  result := 0;
  for i := Low(list) to High(list) do
    result := result+list[i];
end;

procedure EquilibriumIndex(const    list:tnumList;
                              var indices:tresList);
var
  pC : ^tEquiData;
  LeftSum,
  RightSum : tEquiData;
  i,idx,HiList: integer;

begin
  HiList := High(List);
  RightSum :=ArraySum(list);
  setlength(indices,10);
  idx := 0;

  i := -Hilist;
  pC := @List[0];
  LeftSum:= 0;
  repeat
    Rightsum:= RightSum-pC^;
    IF LeftSum = RightSum then
    Begin
      indices[idx] := Hilist+i;
      inc(idx);
      IF idx > high(indices) then
        setlength(indices, idx+10);
    end;
    inc(i);
    leftSum := leftsum+pC^;
    inc(pC);
  until i>=0;
  leftSum := leftsum+pC^;
  IF LeftSum = RightSum then
  Begin
    indices[idx] := Hilist+i;
    inc(idx);
  end;
  setlength(indices,idx);
end;

procedure TestRun(const numbers:tnumList);
var
  indices : tresList;
  i: integer;
Begin
  write('List of numbers:     ');
  for i := low(numbers) to high(numbers) do
    write(numbers[i]:3);
  writeln;
  EquilibriumIndex(numbers,indices);
  write('Equilibirum indices: ');
  EquilibriumIndex(numbers,indices);
  for i := low(indices) to high(indices) do
    write(indices[i]:3);
  writeln;
  writeln;
end;

var
  numbers: tnumList;
  I: integer;
begin
  setlength(numbers,High(cNumbers)-Low(cNumbers)+1);
  move(cNumbers[Low(cNumbers)],numbers[0],sizeof(cnumbers));
  TestRun(numbers);
  for i := low(numbers) to high(numbers) do
    numbers[i]:= 0;
  TestRun(numbers);
end.
