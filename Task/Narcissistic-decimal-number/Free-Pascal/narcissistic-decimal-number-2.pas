program PowerOwnDigits;
{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$COPERATORS ON}
{$ELSE}{$APPTYPE CONSOLE}{$ENDIF}
uses
  SysUtils;

const
  MAXBASE = 10;
  MaxDgtVal = MAXBASE - 1;
  MaxDgtCount = 19;
type
  tDgtCnt = 0..MaxDgtCount;
  tValues = 0..MaxDgtVal;
  tUsedDigits = array[0..23] of Int8;
  tpUsedDigits = ^tUsedDigits;
  tPower = array[tValues] of Uint64;
var
  PowerDgt: array[tDgtCnt] of tPower;
  Min10Pot : array[tDgtCnt] of Uint64;
  gblUD  : tUsedDigits;
  CombIdx: array of Int8;
  Numbers : array of Uint64;
  rec_cnt : NativeInt;

  procedure OutUD(const UD:tUsedDigits);
  var
    i : integer;
  begin
    For i in tValues do
      write(UD[i]:3);
    writeln;
    For i := 0 to MaxDgtCount do
      write(CombIdx[i]:3);
    writeln;
  end;

  function InitCombIdx(ElemCount: Byte): pbyte;
  begin
    setlength(CombIdx, ElemCount + 1);
    Fillchar(CombIdx[0], sizeOf(CombIdx[0]) * (ElemCount + 1), #0);
    Result := @CombIdx[0];
    Fillchar(gblUD[0], sizeOf(gblUD[0]) * (ElemCount + 1), #0);
    gblUD[0]:= 1;
  end;

  function Init(ElemCount:byte):pByte;
  var
    pP1,Pp2 : pUint64;
    i, j: Int32;
  begin
    Min10Pot[0]:= 0;
    Min10Pot[1]:= 1;
    for i := 2 to High(tDgtCnt) do
      Min10Pot[i]:=Min10Pot[i-1]*MAXBASE;

    pP1 := @PowerDgt[low(tDgtCnt)];
    for i in tValues do
      pP1[i] := 1;
    pP1[0] := 0;
    for j := low(tDgtCnt) + 1 to High(tDgtCnt) do
    Begin
      pP2 := @PowerDgt[j];
      for i in tValues do
        pP2[i] := pP1[i]*i;
      pP1 := pP2;
    end;
    result := InitCombIdx(ElemCount);
    gblUD[0]:= 1;
  end;

  function GetPowerSum(minpot:nativeInt;digits:pbyte;var UD :tUsedDigits):NativeInt;
  var
    pPower : pUint64;
    res,r  : Uint64;
    dgt :Int32;
  begin
    r := Min10Pot[minpot];
    dgt := minpot;
    res := 0;
    pPower := @PowerDgt[minpot,0];
    repeat
      dgt -=1;
      res += pPower[digits[dgt]];
    until dgt=0;
    //check if res within bounds of digitCnt
    result := 0;
    if (res<r) or (res>r*MAXBASE) then  EXIT;

    //convert res into digits
    repeat
      r := res DIV MAXBASE;
      result+=1;
      UD[res-r*MAXBASE]-= 1;
      res := r;
    until r = 0;
  end;

  procedure calcNum(minPot:Int32;digits:pbyte);
  var
    UD :tUsedDigits;
    res: Uint64;
    i: nativeInt;
  begin
    UD := gblUD;
    If GetPowerSum(minpot,digits,UD) <>0 then
    Begin
      //don't check 0
      i := 1;
      repeat
        If UD[i] <> 0 then
          Break;
        i +=1;
      until i > MaxDgtVal;

      if i > MaxDgtVal then
      begin
        res := 0;
        for i := minpot-1 downto 0 do
          res += PowerDgt[minpot,digits[i]];
        setlength(Numbers, Length(Numbers) + 1);
        Numbers[high(Numbers)] := res;
      end;
    end;
  end;

  function NextCombWithRep(pComb: pByte;pUD :tpUsedDigits;MaxVal, ElemCount: UInt32): boolean;
  var
    i,dgt: NativeInt;
  begin
    i := -1;
    repeat
      i += 1;
      dgt := pComb[i];
      if dgt < MaxVal then
        break;
      dec(pUD^[dgt]);
    until i >= ElemCount;
    Result := i >= ElemCount;

    if i = 0 then
    begin
      dec(pUD^[dgt]);
      dgt +=1;
      pComb[i] := dgt;
      inc(pUD^[dgt]);
    end
    else
    begin
      //decrements digit 0 too.This is false, but not checked.
      dec(pUD^[dgt]);
      dgt +=1;
      pUD^[dgt]:=i+1;
      repeat
        pComb[i] := dgt;
        i -= 1;
      until i < 0;
    end;
  end;

var
  digits : pByte;
  T0 : Int64;
  tmp: Uint64;
  i, j : Int32;

begin
  digits := Init(MaxDgtCount);
  T0 := GetTickCount64;
  rec_cnt := 0;
  // i > 0
  For i := 2 to MaxDgtCount do
  Begin
    digits := InitCombIdx(MaxDgtCount);
    repeat
      calcnum(i,digits);
      inc(rec_cnt);
    until NextCombWithRep(digits,@gblUD,MaxDgtVal,i);
    writeln(i:3,' digits with ',Length(Numbers):3,' solutions in ',GetTickCount64-T0:5,' ms');
  end;
  T0 := GetTickCount64-T0;
  writeln(rec_cnt,' recursions');

  //sort
  for i := 0 to High(Numbers) - 1 do
    for j := i + 1 to High(Numbers) do
      if Numbers[j] < Numbers[i] then
      begin
        tmp := Numbers[i];
        Numbers[i] := Numbers[j];
        Numbers[j] := tmp;
      end;

  setlength(Numbers, j + 1);
  for i := 0 to High(Numbers) do
     writeln(i+1:3,Numbers[i]:20);
  setlength(Numbers, 0);
  setlength(CombIdx,0);
  {$IFDEF WINDOWS}
  readln;
  {$ENDIF}
end.
