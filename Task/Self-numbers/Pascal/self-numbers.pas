program selfnumb;
{$IFDEF FPC}
  {$MODE Delphi}
  {$Optimization ON,ALL}
{$IFEND}
{$IFDEF DELPHI} {$APPTYPE CONSOLE} {$IFEND}
uses
  sysutils;
const
  MAXCOUNT =103*10000*10000+11*9+ 1;
type
  tDigitSum9999 = array[0..9999] of Uint8;
  tpDigitSum9999 = ^tDigitSum9999;
var
  DigitSum9999 : tDigitSum9999;
  sieve : array of boolean;

procedure dosieve;
var
  pSieve : pBoolean;
  pDigitSum :tpDigitSum9999;
  n,c,b,a,s : NativeInt;
Begin
  pSieve := @sieve[0];
  pDigitSum := @DigitSum9999[0];
  n := 0;
  for a := 0 to 102 do
    for b := 0 to 9999 do
    Begin
      s := pDigitSum^[a]+pDigitSum^[b]+n;
      for c := 0 to 9999 do
      Begin
        pSieve[pDigitSum^[c]+s] := true;
        s+=1;
      end;
      inc(n,10000);
    end;
end;

procedure InitDigitSum;
var
  i,d,c,b,a : NativeInt;
begin
  i := 9999;
  for a := 9 downto 0 do
    for b := 9 downto 0 do
      for c := 9 downto 0 do
        for d := 9 downto 0 do
        Begin
          DigitSum9999[i] := a+b+c+d;
          dec(i);
        end;
end;

procedure OutPut(cnt,i:NativeUint);
Begin
  writeln(cnt:10,i:12);
end;

var
  pSieve : pboolean;
  T0 : Uint64;
  i,cnt,limit,One: NativeUInt;
BEGIN
  setlength(sieve,MAXCOUNT);
  pSieve := @sieve[0];
  T0 := GetTickCount64;
  InitDigitSum;
  dosieve;
  writeln('Sievetime : ',(GetTickCount64-T0 )/1000:8:3,' sec');
  //find first 50
  cnt := 0;
  for i := 0 to MAXCOUNT do
  Begin
    if NOT(pSieve[i]) then
    Begin
      inc(cnt);
      if cnt <= 50 then
        write(i:4)
      else
        BREAK;
    end;
  end;
  writeln;
  One := 1;
  limit := One;
  cnt := 0;
  for i := 0 to MAXCOUNT do
  Begin
    inc(cnt,One-Ord(pSieve[i]));
    if cnt = limit then
    Begin
      OutPut(cnt,i);
      limit := limit*10;
    end;
  end;
END.
