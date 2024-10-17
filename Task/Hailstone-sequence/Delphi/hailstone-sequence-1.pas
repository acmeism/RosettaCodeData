program ShowHailstoneSequence;

{$APPTYPE CONSOLE}

uses SysUtils, Generics.Collections;

procedure GetHailstoneSequence(aStartingNumber: Integer; aHailstoneList: TList<Integer>);
var
  n: Integer;
begin
  aHailstoneList.Clear;
  aHailstoneList.Add(aStartingNumber);
  n := aStartingNumber;

  while n <> 1 do
  begin
    if Odd(n) then
      n := (3 * n) + 1
    else
      n := n div 2;
    aHailstoneList.Add(n);
  end;
end;

var
  i: Integer;
  lList: TList<Integer>;
  lMaxSequence: Integer;
  lMaxLength: Integer;
begin
  lList := TList<Integer>.Create;
  try
    GetHailstoneSequence(27, lList);
    Writeln(Format('27: %d elements', [lList.Count]));
    Writeln(Format('[%d,%d,%d,%d ... %d,%d,%d,%d]',
      [lList[0], lList[1], lList[2], lList[3],
      lList[lList.Count - 4], lList[lList.Count - 3], lList[lList.Count - 2], lList[lList.Count - 1]]));
    Writeln;

    lMaxSequence := 0;
    lMaxLength := 0;
    for i := 1 to 100000 do
    begin
      GetHailstoneSequence(i, lList);
      if lList.Count > lMaxLength then
      begin
        lMaxSequence := i;
        lMaxLength := lList.Count;
      end;
    end;
    Writeln(Format('Longest sequence under 100,000: %d with %d elements', [lMaxSequence, lMaxLength]));
  finally
    lList.Free;
  end;

  Readln;
end.
