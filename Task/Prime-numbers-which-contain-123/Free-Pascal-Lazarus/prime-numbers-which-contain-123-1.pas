program test_123_primes;
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
uses
  SysUtils,StrUtils,primsieve;

const
  MaxTotLen = 1000*1000*1000;
var
  PowLimit: nativeint;
  TtlCnt,PrmCnt: nativeint;
  p: nativeint;

begin
  Writeln(' Total count           Limit     primes count for test');
  PowLimit := 1000;
  p := nextprime;// =2
  TtlCnt := 0;
  PrmCnt := 0;
  repeat
    repeat
      PrmCnt +=1;
      inc(TtlCnt,Ord(pos('123',IntToStr(p))>0));
      p := nextprime;
    until p>PowLimit;
    writeln(Numb2Usa(IntToStr(TtlCnt)):12,
           Numb2Usa(IntToStr(powLimit)):16,
           Numb2Usa(IntToStr(PrmCnt)):16);
    PowLimit *= 10;
  until PowLimit> MaxTotLen;
end.
