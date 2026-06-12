program Inconsummate;
{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$CODEALIGN proc=8,loop=1}
{$ENDIF}
uses
  sysutils;
const
  base = 10;
  DgtSumLmt = base*base*base*base*base;
type
  tDgtSum = array[0..DgtSumLmt-1] of byte;
var
  DgtSUm : tDgtSum;
  max: Uint64;
procedure Init(var ds:tDgtSum);
var
  i,l,k0,k1: NativeUint;
Begin
  For i := 0 to base-1 do
    ds[i] := i;
  k0 := base;
  repeat
    k1 := k0-1;
    For i := 1 to base-1 do
      For l := 0 to k1 do
      begin
        ds[k0] := ds[l]+i;
        inc(k0);
      end;
  until k0 >= High(ds);
end;


function GetSumOfDecDigits(n:Uint64):NativeUint;
var
  r,d: NativeUint;
begin
  result := 0;
  repeat
    r := n DIv DgtSumLmt;
    d := n-r* DgtSumLmt;
    result +=DgtSUm[d];
    n := r;
  until r = 0;
end;

function OneTest(n:Nativeint):Boolean;
var
  i,d : NativeInt;
begin
  result := true;
  d := n;
  For i := 1 TO 121 DO
  begin
    IF GetSumOfDecDigits(n)= i then
    Begin
      if i > max then
        max := i;
      Exit(false);
    end;
    n +=d;
  end;
end;

var
  d,
  cnt,lmt: Uint64;
begin
  Init(DgtSUm);
  cnt := 0;
  For d := 1 to 527 do//5375540350 do
  begin
    if OneTest(d) then
    begin
      inc(cnt);
      write(d:5);
      if cnt mod 10 = 0 then writeln;
    end;
  end;
  writeln;
  writeln('Count      Number(count) Maxfactor needed');
  cnt := 0;
  max := 0;
  lmt := 10;
  For d := 1 to 50332353 do // 5260629551 do
  begin
    if OneTest(d) then
    begin
      inc(cnt);
      if cnt = lmt then
      begin
       writeln(cnt:10,d:12,max:5);
       lmt *=10;
      end;
    end;
  end;
  writeln(cnt);
end.
