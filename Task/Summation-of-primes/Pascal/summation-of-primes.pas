program SumPrimes;
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF Windows}{$APPTYPE CONSOLE}{$ENDIF}
uses
  SysUtils,primsieve;
var
  p,sum : NativeInt;
begin
  sum := 0;
  p := 0;
  repeat inc(sum,p);p := Nextprime until p >= 2*1000*1000;
  writeln(sum);
  {$IFDEF WINDOWS} readln;{$ENDIF}
end.
