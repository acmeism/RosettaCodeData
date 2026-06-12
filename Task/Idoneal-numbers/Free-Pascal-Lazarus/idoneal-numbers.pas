program idoneals;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,ALL}
  {$CODEALIGN loop=1}
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  sysutils;
const
 runs = 1000;
type
  Check_isIdoneal = function(n: Uint32): boolean;

var
  idoneals : array of Uint32;

function isIdonealOrg(n: Uint32):Boolean;
var
  a,b,c,sum : NativeUint;
begin
  For a := 1 to n do
    For b := a+1 to n do
    Begin
      if (a*b + a + b > n) then
        BREAK;
      For c := b+1 to n do
      begin
        sum := a * b + b * c + a * c;
        if (sum = n) then
          EXIT(false);
        if (sum > n) then
         BREAK;
      end;
    end;
  exit(true);
end;

function isIdoneal(n: Uint32):Boolean;
var
  a,b,c,axb,ab,sum : Uint32;
begin
  For a := 1 to n do
  Begin
    ab := a+a;
    axb := a*a;
    For b := a+1 to n do
    Begin
      axb += a;
      ab +=1;
      sum := axb + b*ab;
      if (sum > n) then
        BREAK;
      For c := b+1 to n do
      begin
        sum += ab;
        if (sum = n) then
          EXIT(false);
        if (sum > n) then
          BREAK;
      end;
    end;
  end;
  EXIT(true);
end;

function Check(f:Check_isIdoneal):Uint32;
var
  n : Uint32;
begin
  result := 0;
  For n := 1 to 1848 do
    if f(n) then
    Begin
      inc(result);
      setlength(idoneals,result);   idoneals[result-1] := n;
    end;
end;

procedure OneRun(f:Check_isIdoneal);
var
  T0 : Int64;
  i,l : Uint32;
begin
  T0 := GetTickCount64;
  For i := runs-1 downto 0 do
    l:= check(f);
  T0 := GetTickCount64-T0;

  dec(l);
  For i := 0 to l do
  begin
    write(idoneals[i]:5);
    if (i+1) mod 13 = 0 then
      writeln;
  end;

  Writeln(T0/runs:7:3,' ms per run');
end;

BEGIN
  OneRun(@isIdonealOrg);
  OneRun(@isIdoneal);
END.
