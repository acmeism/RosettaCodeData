program ShowHailstoneSequence;
{$IFDEF FPC}
  {$MODE delphi} //or objfpc
{$Else}
  {$Apptype Console} // for delphi
{$ENDIF}
uses
  SysUtils;// format
const
  maxN = 10*1000*1000;// for output 1000*1000*1000

type
  tiaArr = array[0..1000] of Uint64;
  tIntArr = record
               iaMaxPos : integer;
               iaArr    : tiaArr
            end;
  tpiaArr = ^tiaArr;

function HailstoneSeqCnt(n: UInt64): NativeInt;
begin
  result := 0;
  //ensure n to be odd
  while not(ODD(n)) do
  Begin
    inc(result);
    n := n shr 1;
  end;

  IF n > 1 then
  repeat
    //now n == odd -> so two steps in one can be made
    repeat
      n := (3*n+1) SHR 1;inc(result,2);
    until NOT(Odd(n));
    //now n == even -> so only one step can be made
    repeat
      n := n shr 1;      inc(result);
    until odd(n);
  until n = 1;
end;

procedure GetHailstoneSequence(aStartingNumber: NativeUint;var aHailstoneList: tIntArr);
var
  maxPos: NativeInt;
  n: UInt64;
  pArr : tpiaArr;
begin
  with aHailstoneList do
  begin
    maxPos := 0;
    pArr := @iaArr;
  end;
  n  := aStartingNumber;
  pArr^[maxPos] := n;
  while n <> 1 do
  begin
    if odd(n) then
      n := (3*n+1)
    else
      n := n shr 1;
    inc(maxPos);
    pArr^[maxPos] := n;
  end;
  aHailstoneList.iaMaxPos  := maxPos;
end;

var
  i,Limit: NativeInt;
  lList: tIntArr;
  lAverageLength:Uint64;
  lMaxSequence: NativeInt;
  lMaxLength,lgth: NativeInt;
begin
  lList.iaMaxPos := 0;
  GetHailstoneSequence(27, lList);//319804831
  with lList do
  begin
    Limit := iaMaxPos;
    writeln(Format('sequence of %d has %d  elements',[iaArr[0],Limit+1]));
    write(iaArr[0],',',iaArr[1],',',iaArr[2],',',iaArr[3],'..');
    For i := iaMaxPos-3 to iaMaxPos-1 do
       write(iaArr[i],',');
    writeln(iaArr[iaMaxPos]);
  end;
  Writeln;

  lMaxSequence := 0;
  lMaxLength := 0;
  i := 1;
  limit := 10*i;
  writeln(' Limit      : number with max length | average length');
  repeat
    lAverageLength:= 0;
    repeat
      lgth:= HailstoneSeqCnt(i);
      inc(lAverageLength, lgth);
      if lgth >= lMaxLength then
      begin
        lMaxSequence := i;
        lMaxLength := lgth+1;
      end;
      inc(i);
    until i = Limit;
    Writeln(Format(' %10d : %9d    |  %4d   |      %7.3f',
                   [limit,lMaxSequence, lMaxLength,0.9*lAverageLength/Limit]));
    limit := limit*10;
  until Limit > maxN;
end.
