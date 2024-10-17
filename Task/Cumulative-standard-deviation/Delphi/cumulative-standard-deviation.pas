program prj_CalcStdDerv;

{$APPTYPE CONSOLE}

uses
  Math;

var Series:Array of Extended;
    UserString:String;


function AppendAndCalc(NewVal:Extended):Extended;

begin
  setlength(Series,high(Series)+2);
  Series[high(Series)] := NewVal;
  result := PopnStdDev(Series);
end;

const data:array[0..7] of Extended =
  (2,4,4,4,5,5,7,9);

var rr: Extended;
begin
  setlength(Series,0);
  for rr in data do
    begin
      writeln(rr,' -> ',AppendAndCalc(rr));
    end;
  Readln;
end.
