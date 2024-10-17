program ShowHailstoneSequence;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Types,
  System.Threading,
  System.SyncObjs,
  Boost.Algorithm,
  Boost.Int,
  System.Diagnostics;

var
  lList: TIntegerDynArray;
  lMaxSequence, lMaxLength, i: Integer;
  StopWatch: TStopwatch;

begin
  lList := Hailstone(27);
  Writeln(Format('27: %d elements', [lList.Count]));
  Writeln(lList.toString(4), #10);

  lMaxSequence := 0;
  lMaxLength := 0;

  StopWatch := TStopwatch.Create;
  StopWatch.Start;

  TParallel.for (1, 1, 100000,
    procedure(idx: Integer)
    var
      lList: TIntegerDynArray;
    begin
      lList := Hailstone(idx);
      if lList.Count > lMaxLength then
      begin
        TInterlocked.Exchange(lMaxSequence, idx);
        TInterlocked.Exchange(lMaxLength, lList.Count);
      end;
    end);

  StopWatch.Stop;

  Write(Format('Longest sequence under 100,000: %d with %d elements', [lMaxSequence,
    lMaxLength]));

  Writeln(Format(' in %d ms', [StopWatch.ElapsedMilliseconds]));

  Readln;
end.
