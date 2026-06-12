program NumberExpDgtSum;
{$IFDEF FPC} {$MODE DELPHI} {$OPTIMIZATION ON,ALL} {$ENDIF}
uses
  sysutils;
const
  LongWordDec = 1000*1000*1000;
  ElemCount = 8000;
  DgtCount =9*ElemCount;
type
  tElem = 0..LongWordDec-1;
  tNum = array of Uint32;

var
  DgtSum999 : array[0..999] of byte;
  foundPot : array[0..15] of Uint32;

procedure InitDgtSum;
var
  pDgtSUm :  pByte;
  i,j,k,sumij : Int32;
Begin
  pDgtSUm := @DgtSum999[0];
  For i := 0 to 9 do
    for j := 0 to 9 do
    begin
      sumij := i+j;
      for k := 0 to 9 do
      begin
        pDgtSum^:= sumij;
        inc(pDgtSum);
        inc(sumij);
      end
    end
end;

procedure OutFound(n,found:INt32);
var
  i : Int32;
Begin
  if found >0 then
  begin
    dec(found);
    write(' max pot diff: ',foundPot[found]-foundPot[0]:4);
    write(n:7,'^ ');
    For i := 0 to found do
      write(foundPot[i]:4);
    writeln;
  end;
end;

procedure OutNum(const Num:tNum;MaxIdx:NativeInt);
var
  i : NativeInt;
Begin
  writeln(#13#10,MaxIdx);
  write(Num[MaxIdx]);
  For i := MaxIdx-1 downto 0 do
    write(Format('%.9d',[Num[i]]));
  writeln;
end;

function GetDgtSum(const Num:tNum;MaxIdx:NativeInt):Int32;
var
  n,q: UInt32;
begin
  result := 0;
  repeat
    n := num[MaxIdx];
    q := n div 1000;
    result += DgtSum999[n-q*1000];
    n := q;
    q := n div 1000;
    result += DgtSum999[n-q*1000];
    result += DgtSum999[q];
    dec(MaxIdx);
  until MaxIdx<0;
end;

function getNextPot(n:tElem;MaxIdx:Uint32;var Num:tNum):Integer;
// const LongWordDec = 1000*1000*1000;
var
  pNum : pUint32;
  prod: Uint64;
  idx : NativeInt;
  carry : Uint32;
begin
  carry := 0;
  pNum :=@Num[0];
  For idx := 0 to MaxIdx do
  Begin
    prod  := n*pNum[idx]+Carry;
    Carry := prod Div LongWordDec;
    pNum[idx] := Prod - Carry*LongWordDec;
  end;
  IF Carry <> 0 then
  Begin
    inc(MaxIdx);
    Num[MaxIdx] := Carry;
  End;
  result := MaxIdx;
end;

function CheckOneN(n : tElem;var num:tNUm):Int32;
var
  MaxIdx,DgtSum,i,lmt,lmt_n: Uint32;
begin
  result := 0;
  MaxIdx := 0;
  Num[0] := n;
  //power of 10 -> always stays 1
  if GetDgtSum(Num,MaxIdx) = 1  then
    EXIT;
  //check stop limits by count of decimal places
  lmt := trunc(ln(n)/ln(10))+1;
  case lmt of
    1: lmt := 9*n;
    2: lmt := 3*n;
    3: lmt := 2*n;
    4: lmt := 5*n DIV 4;
  else
    lmt := 9*n DIV 8;
  end;
  lmt_n := n;
  i := 2;
  repeat
    MaxIdx := getNextPot(n,MaxIdx,num);
    if MaxIDx >= ElemCount then
      BREAK;
    DgtSum := GetDgtSum(num,MaxIDx);
    if DgtSum = n  then
    begin
      foundPot[result] := i;
      result += 1;
      lmt_n := foundPot[0] +144;// til 90000
    end;
    if DgtSum> lmt  then
      BREAK;
    inc(i);
  until i> lmt_n;
  if MaxIDx >= ElemCount then
    writeln(n,' too small');
end;

var
  num : tNum;
  cnt,found: NativeInt;
  n : tElem;
Begin
  InitDgtSum;
  setlength(Num,ElemCount+1);

  writeln('First twenty-five integers that are equal to the digital sum of that integer raised to some power: ');
  cnt := 0;
  n := 2;
  repeat
    inc(n);
    found:= CheckOneN(n,num);
    if found >0 then
    begin
      OutFound(n,found);
      inc(cnt);
    end;
  until cnt>25;

  writeln;
  writeln('First 100 that satisfy that condition in three or more ways:');
  cnt := 0;
  n := 2;
  repeat
    inc(n);
    found:= CheckOneN(n,num);
    if found >=3 then
    begin
      OutFound(n,found);
      inc(cnt);
    end;
  until cnt>=32;//cnt>=100;
end.
