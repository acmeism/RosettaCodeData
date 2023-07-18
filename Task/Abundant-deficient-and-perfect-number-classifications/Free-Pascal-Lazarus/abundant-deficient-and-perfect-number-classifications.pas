program KindOfN; //[deficient,perfect,abundant]
{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$COPERATORS ON}{$CODEALIGN proc=16}
{$ENDIF}
{$IFDEF WINDOWS} {$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils,PrimeDecomp // limited to 1.2e11
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
//alternative copy and paste PrimeDecomp.inc for TIO.RUN
{$I PrimeDecomp.inc}
type
  tKindIdx = 0..2;//[deficient,perfect,abundant];
  tKind = array[tKindIdx] of Uint64;

procedure GetKind(Limit:Uint64);
var
  pPrimeDecomp :tpPrimeFac;
  SumOfKind : tKind;
  n: NativeUInt;
  c: NativeInt;
  T0:Int64;
Begin
  writeln('Limit:     ',LIMIT);
  T0 := GetTickCount64;
  fillchar(SumOfKind,SizeOf(SumOfKind),#0);
  n := 1;
  Init_Sieve(n);
  repeat
    pPrimeDecomp:= GetNextPrimeDecomp;
    c := pPrimeDecomp^.pfSumOfDivs-2*n;
    c := ORD(c>0)-ORD(c<0)+1;//sgn(c)+1
    inc(SumOfKind[c]);
    inc(n);
  until n > LIMIT;
  T0 := GetTickCount64-T0;
  writeln('deficient: ',SumOfKind[0]);
  writeln('abundant:  ',SumOfKind[2]);
  writeln('perfect:   ',SumOfKind[1]);
  writeln('runtime ',T0/1000:0:3,' s');
  writeln;
end;

Begin
  InitSmallPrimes; //using PrimeDecomp.inc
  GetKind(20000);
  GetKind(10*1000*1000);
  GetKind(524*1000*1000);
end.
