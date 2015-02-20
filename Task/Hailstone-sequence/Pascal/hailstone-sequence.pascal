program ShowHailstoneSequence;
{$IFDEF FPC}
  {$MODE delphi} //or objfpc
{$Else}
  {$Apptype Console} // for delphi
{$ENDIF}

uses
  SysUtils;// format
type
  tIntArr = record
               iaAktPos : integer;
               iaMaxPos : integer;
               iaArr    : array of integer;
            end;

procedure GetHailstoneSequence(aStartingNumber: Integer;var aHailstoneList: tIntArr);
var
  n: UInt64;
begin
  with aHailstoneList do
  begin
    iaAktPos := 0;
    iaArr[iaAktPos] := aStartingNumber;
    n := aStartingNumber;
    while n <> 1 do
    begin
      if Odd(n) then
        n := (3 * n) + 1
      else
        n := n div 2;
      inc(iaAktPos);
      IF iaAktPos>iaMaxPos then
      Begin
        iaMaxPos := round(iaMaxPos*1.62)+2;
        setlength(iaArr,iaMaxPos+1);
      end;
      iaArr[iaAktPos] := n;
    end;
  end;
end;

var
  i,Limit: Integer;
  lList: tIntArr;
  lMaxSequence: Integer;
  lMaxLength: Integer;
begin
  try
    with lList do
    begin
      setlength(iaArr,0+1);
      iaMaxPos := 0;
      iaAktPos := 0;
    end;

    GetHailstoneSequence(27, lList);
    with lList do
    begin
      i := iaAktPos+1;
      Writeln(Format('27: %d elements', [i]));
      Writeln(Format('[%d,%d,%d,%d ... %d,%d,%d,%d]',
        [iaArr[0], iaArr[1], iaArr[2], iaArr[3],
      iaArr[i - 4], iaArr[i - 3], iaArr[i - 2], iaArr[i - 1]]));
      Writeln;

      lMaxSequence := 0;
      lMaxLength := 0;
      limit := 10;
      for i := 1 to 10000000 do
      begin
        GetHailstoneSequence(i, lList);
        if iaAktPos >= lMaxLength then
        begin
          IF i> limit then
          begin
            Writeln(Format('Longest sequence under %8d : %7d with %3d elements',
                           [limit,lMaxSequence, lMaxLength]));
            limit := limit*10;
          end;
          lMaxSequence := i;
          lMaxLength := iaAktPos+1;
        end;
      end;
      Writeln(Format('Longest sequence under %8d : %7d with %3d elements',
                     [limit,lMaxSequence, lMaxLength]));

    end;
  finally
    setlength(lList.iaArr,0);
  end;
  writeln('game over, wait for >ENTER< ');
  Readln;
end.
