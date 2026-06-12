program euler52;
{$IFDEF FPC}
  {$MOde DElphi} {$Optimization On,ALL}
{$else}
  {$Apptype console}
{$ENDIF}
uses
  sysutils;
const
  BaseConvDgt :array[0..35] of char = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  MAXBASE = 12;//
type
  TUsedDigits  =  array[0..MAXBASE-1] of byte;
  tDigitsInUse = set of 0..MAXBASE-1;
var
{$ALIGN 16}
  UsedDigits :tUsedDigits;
{$ALIGN 16}
  gblMaxDepth,
  steps,
  base,maxmul : NativeInt;
  found : boolean;

  function AddOne(var SumDigits:tUsedDigits;const UsedDigits: tUsedDigits):NativeInt;forward;

function ConvBaseToStr(const UsedDigits :tUsedDigits):string;
var
  i,j:NativeUint;
Begin
  setlength(result,gblMaxdepth+1);
  j := 1;
  For i := 0 to gblMaxdepth do
  begin
    result[j] := BaseConvDgt[UsedDigits[i]];
    inc(j);
  end;
end;

procedure Out_MaxMul(const UsedDigits :tUsedDigits);
var
  j : NativeInt;
  SumDigits :tUsedDigits;
begin
  writeln('With ',gblMaxdepth+1,' digits');
  sumDigits := UsedDigits;
  write(' 1x  :',ConvBaseToStr(UsedDigits));
  For j := 2 to MaxMul do
  Begin
    AddOne(SumDigits,UsedDigits);
    write(j:2,'x:',ConvBaseToStr(SumDigits));
  end;
  writeln;
  writeln('steps ',steps);
end;

procedure InitUsed;
Var
 i : NativeInt;
Begin
  For i := 2 to BASE-1 do
    UsedDigits[i] := i;
  UsedDigits[0] := 1;
  UsedDigits[1] := 0;
end;

function GetUsedSet(const UsedDigits: tUsedDigits):tDigitsInUse;
var
  i : NativeInt;
begin
  result := [];
  For i := 0 to gblMaxDepth do
    include(result,UsedDigits[i]);
end;

function AddOne(var SumDigits:tUsedDigits;const UsedDigits: tUsedDigits):NativeInt;
//add and return carry
var
  s,i: NativeUint;
begin
  result := 0;
  For i := gblMaxdepth downto 0 do
  Begin
    s := UsedDigits[i]+SumDigits[i]+result;
    result := ord(s >= BASE);// 0 or 1
//    if result >0 then s -= base;//runtime Base=12 Done in 2.097 -> Done in 1.647
    s -= result*base;
    SumDigits[i] := s;
  end;
end;

function CheckMultiples(const UsedDigits: tUsedDigits;OrgInUse:tDigitsInUse):NativeInt;
var
{$ALIGN 16}
  SumDigits :tUsedDigits;
  j : integer;
begin
  result := 0;
  SumDigits := UsedDigits;
  j := 2;// first doubled
  repeat
    if AddOne(SumDigits,UsedDigits) >0 then
      break;
    if GetUsedSet(SumDigits) <> OrgInUse then
      break;
    inc(j);
  until j > MaxMul;
  found := j > MaxMul;
  if found then
    Out_MaxMul(UsedDigits);
end;

procedure GetNextUsedDigit(StartIdx:NativeInt);
var
  i : NativeInt;
  DigitTaken: Byte;
Begin
  For i := StartIDx to BASE-1 do
  Begin
    //Stop after first found
    if found then  BREAK;
    DigitTaken := UsedDigits[i];
    //swap i with Startidx
    UsedDigits[i]:= UsedDigits[StartIdx];
    UsedDigits[StartIdx] := DigitTaken;

    inc(steps);
    IF StartIdx <gblMaxDepth then
      GetNextUsedDigit(StartIdx+1)
    else
      CheckMultiples(UsedDigits,GetUsedSet(UsedDigits));

    //undo swap i with Startidx
    UsedDigits[StartIdx] := UsedDigits[i];
    UsedDigits[i]:= DigitTaken;
  end;
end;

var
  T : INt64;
Begin
  T := GetTickCount64;
//  For base := 4 to MAXBASE do
  For base := 4 to 10 do
  Begin
    Writeln('Base ',base);
    MaxMul := Base-2;
    If base = 10 then
      MaxMul := 6;
    InitUsed;
    steps := 0;
    For gblMaxDepth := 1 to BASE-1 do
    Begin
      found := false;
      GetNextUsedDigit(1);
    end;
    writeln;
  end;
  T := GetTickCount64-T;
  write('Done in ',T/1000:0:3,' s');
  {$IFDEF WINdows}
    readln;
  {$ENDIF}
end.
