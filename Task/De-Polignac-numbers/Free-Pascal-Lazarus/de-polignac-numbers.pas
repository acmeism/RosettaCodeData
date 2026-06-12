program DePolignacNum;
{$IFDEF FPC}{$MODE DELPHI}{$Optimization ON,ALL} {$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils;

function IsPrime(n: Uint32): boolean;
{Fast, optimised prime test}
const
  DeltaMOD235: array[0..7] of Uint32 =(4,2,4,2,4,6,2,6);
var
  pr,idx : NativeUint;
begin
  if n < 32 then
    Exit(n in [2,3,5,7,11,13,17,19,23,29,31]);
  IF n AND 1 = 0 then EXIT(false);
  IF n mod 3 = 0 then EXIT(false);
  IF n mod 5 = 0 then EXIT(false);
  pr := 7;
  idx := 0;
  repeat
    if sqr(pr) >n then
      EXIT(true);
    if n mod pr = 0 then
      EXIT(false);
    pr += DeltaMOD235[idx];
    idx := (idx+1) AND 7;
  until false;
end;

function IsPolignac(N: Uint32): boolean;
{We are looking for 2^I + Prime = N
Therefore this 2^I - N should be prime}
var
  Pw2: Uint32;
begin
  Pw2:=1;
  {Test all powers of less than N}
  while Pw2<N do
  begin
    {If the difference is prime, it is not Polignac}
    if IsPrime(N-Pw2) then
      EXIT(false);
    //Pw2:=Pw2 shl 1;
    Pw2 +=Pw2;
  end;
  Result:=True;
end;

procedure ShowPolignacNumbers;
{Show the first 50, 1000th and 10,000th Polignac numbers}
var
  I,Cnt,lmt: Uint32;
  S: string;
begin
  writeln('First 50 Polignac numbers:');
  I:=1; Cnt:=0; S:='';
  {Iterate through all odd numbers}
  lmt := 10;
  while true do
  begin
    if IsPolignac(I) then
    begin
      S:=S+Format('%6.0n',[I*1.0]);
      Inc(Cnt);
      if Cnt = lmt then
      begin
        writeln(S);
        S:='';
        inc(lmt,10);
      end;
    end;
    Inc(I,2);
    if Cnt>=50 then break;
  end;
  writeln;

  lmt := 100;
  repeat
    if IsPolignac(I) then
    begin
      Inc(Cnt);
      if Cnt=lmt then
      begin
        writeln(Format('%10.0nth %10.0n',[cnt*1.0,I*1.0]));
        lmt *= 10;
        if lmt > 10000 then
          BREAK;
      end;
    end;
    Inc(I,2);
  until false;
end;

var
  T : Int64;
BEGIN
  //wait for change in GetTickCount64
  T := GetTickCount64+1;repeat until T <= GetTickCount64;
  ShowPolignacNumbers;
  Writeln(GetTickCount64-T,' ms');
end.
