program cyclops;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,ALL}
  {$CodeAlign proc=32,loop=1}
{$ENDIF}
//extra https://oeis.org/A136098/b136098.txt take ~37 s( TIO.RUN )
uses
  sysutils;
const
  BIGLIMIT = 10*1000*1000;

type
  //number in base 9
  tnumdgts = array[0..10] of byte;
  tpnumdgts = pByte;
  tnum9 = packed record
           nmdgts : tnumdgts;
           nmMaxDgtIdx :byte;
           nmNum  : uint32;
         end;
  tCN = record
          cnRight,
          cnLeft :  tNum9;
          cnNum  :  Uint64;
          cndigits,
          cnIdx  :  Uint32;
        end;
  tCyclopsList = array of Uint64;

  procedure InitCycNum(var cn:tCN);forward;

var
  cnMin,cnPow10Shift,cnPow9 : array[0..15] of Uint64;
  Cyclops :tCyclopsList;

function IndexToCyclops(n:Uint64):tCN;
//zero-based index
var
  dgtCnt,i,num : UInt32;
  q,p9: Uint64;
Begin
  InitCycNum(result);
  if n = 0 then
    EXIT;
  result.cnIdx := n;
  dgtCnt := 0;

  repeat
    p9 := sqr(cnPow9[dgtCnt]);
    if n < p9 then
      break;
    n -= p9;
    inc(dgtCnt)
  until dgtcnt>10;
  dec(dgtCnt);
  with result do
  Begin
    with cnRight do
    Begin
      nmMaxDgtIdx := dgtCnt;
      For i := 0 to dgtCnt do
      begin
        q := n DIV 9;
        nmdgts[i] := n-9*q;
        n := q;
      end;
      num :=0;
      For i := dgtcnt downto 0 do
        num := num*10+nmdgts[i]+1;
      nmNum:= num;
      cnNum := num;
    end;

    with cnLeft do
    Begin
      nmMaxDgtIdx := dgtCnt;
      For i := 0 to dgtCnt do
      begin
        q := n DIV 9;
        nmdgts[i] := n-9*q;
        n := q;
      end;
      num :=0;
      For i := dgtcnt downto 0 do
        num := num*10+nmdgts[i]+1;
      nmNum:= num;
      cnNum += num*cnPow10Shift[dgtCnt];
      cndigits := dgtCnt;
    end;
  end;
end;

procedure Out_Cyclops(const cl:tCyclopsList;colw,colc:NativeInt);
var
  i,n : NativeInt;
Begin
  n := High(cl);
  If n > 100 then
    n := 100;
  For i := 0 to n do
  begin
    write(cl[i]:colw);
    if (i+1) mod colc = 0 then
      writeln;
  end;
  if (i+1) mod colc <> 0 then
    writeln;
  if n< High(cl) then
    writeln(High(cl)+1,' : ',cl[High(cl)]);
end;

procedure InitCnMinPow;
//min = (0,1,11,111,1111,11111,111111,1111111,11111111,...);
var
  i,min,pow,pow9 : Uint64;
begin
  min := 0;
  pow := 100;
  pow9 := 1;
  For i :=0 to High(cnMin) do
  begin
    cnMin[i] := min;
    min := 10*min+1;
    cnPow10Shift[i] := pow;
    pow *= 10;
    cnPow9[i] := pow9;
    pow9 *= 9;
  end;
end;

procedure ClearNum9(var tn:tNum9;idx:Uint32);
begin
  fillchar(tn,SizeOf(tn),#0);
  tn.nmNum := cnMin[idx+1];
end;

Procedure InitCycNum(var cn:tCN);
Begin
  with cn do
  Begin
    cndigits := 0;
    ClearNum9(cnLeft,0);
    ClearNum9(cnRight,0);
    cnNum := 0;
    cnIdx := 0;
  end;
end;

procedure IncNum9(var tn:tNum9);
var
  idx,fac,n: Uint32;
begin
  idx := 0;
  with tn do
  Begin
    fac := 1;
    n := nmdgts[0]+1;
    inc(nmNum);
    repeat
      if n < 9 then
        break;
      inc(nmNum,fac);
      nmdgts[idx] :=0;
      inc(idx);
      fac *= 10;
      n := nmdgts[idx]+1;
    until idx > nmMaxDgtIdx;
    If idx > High(nmdgts) then
      EXIT;
    nmdgts[idx] := n;
    if nmMaxDgtIdx<Idx then
      nmMaxDgtIdx := Idx;
  end;
end;

procedure NextCycNum(var cycnum:tCN);
begin
  with cycnum do
  Begin
    if cnIdx <> 0 then
    begin
      //increment right digits
      IncNum9(cnRight);
      if cnRight.nmMaxDgtIdx > cndigits then
      Begin
        //set right digits to minimum
        ClearNum9(cnRight,cndigits);
        //increment left digits
        IncNum9(cnLeft);
        //One more digit ?
        if cnLeft.nmMaxDgtIdx > cndigits then
        Begin
          inc(cndigits);
          ClearNum9(cnLeft,cndigits);
          ClearNum9(cnRight,cndigits);
          if cndigits>High(tnumdgts) then
            cndigits := High(tnumdgts);
        end;
      end;
      cnNum := cnLeft.nmNum*cnPow10Shift[cndigits]+cnRight.nmNUm;
      inc(cnIdx);
    end
    else
    Begin
      cnNum := 101;
      cnIdx := 1;
    end;
  end;
end;

procedure MakePalinCycNum(var cycnum:tCN);
//make right to be palin of left
var
  n,dgt : Uint32;
  i,j:NativeInt;
Begin
  n := 0;
  with cycnum do
  Begin
    i := 0;
    For j := cnDigits downto 0 do
    begin
      dgt := cnLeft.nmdgts[i];
      cnRight.nmdgts[j] := dgt;
      n := 10*n+(dgt+1);
      inc(i);
    end;
    cnRight.nmNum := n;
    cnNum := cnLeft.nmNum*cnPow10Shift[cndigits]+n;
  end;
end;

procedure IncLeftCn(var cn:tCN);
Begin
  with cn do
  Begin
    //set right digits to minimum
    ClearNum9(cnRight,cndigits);
    //increment left digits
    IncNum9(cnLeft);
    //One more digit ?
    if cnLeft.nmMaxDgtIdx > cndigits then
    Begin
      inc(cndigits);
      ClearNum9(cnLeft,cndigits);
      ClearNum9(cnRight,cndigits);
      if cndigits>High(tnumdgts) then
        cndigits := High(tnumdgts);
    end;
    cnNum := cnLeft.nmNum*cnPow10Shift[cndigits]+cnRight.nmNUm;
  end;
end;

function isPalinCycNum(const cycnum:tCN):boolean;
var
  i,j:NativeInt;
Begin
  with cycnum do
  Begin
    i := cnDigits;
    j := 0;
    repeat
      result := (cnRight.nmdgts[i]=cnLeft.nmdgts[j]);
      if not(result) then
        BREAK;
      dec(i);
      inc(j);
    until i<0;
  end;
end;

function FirstCyclops(cnt:NativeInt):tCN;
var
  i: NativeInt;
begin
  setlength(Cyclops,cnt);
  i := 0;
  InitCycNum(result);
  while i < cnt do
  begin
    Cyclops[i] := result.cnNum;
    inc(i);
    NextCycNum(result);
  end;
  repeat
    NextCycNum(result);
    inc(i);
  until result.cnNum> BIGLIMIT;
end;

function isPrime(n:Uint64):boolean;
var
  p,q : Uint64;
Begin
{
  if n< 4 then
  Begin
    if n < 2 then
      EXIT(false);
    EXIT(true);
  end;
  if n = 5 then
    exit(true);}
  if (n AND 1 = 0) then
    EXIT(false);
  q := n div 3;
  if n - 3*q = 0 then
    EXIT(false);
  p := 5;
  {$CodeAlign loop=1}
  repeat
    q := n div p;
    if n-q*p = 0 then
      EXIT(false);
    p += 2;
    q := n div p;
    if n-q*p = 0 then
      EXIT(false);
    if q < p then
      break;
    p += 4;
  until false;
  EXIT(true);
end;

function FirstPrimeCyclops(cnt:NativeInt):tCN;
var
  i: NativeInt;
begin
  i := 0;
  setlength(Cyclops,cnt);
  InitCycNum(result);
  while i<cnt do
  begin
    if isPrime(result.cnNum) then
    Begin
      Cyclops[i] := result.cnNum;
      inc(i);
    end;
    NextCycNum(result);
  end;
  repeat
    if isPrime(result.cnNum) then
    begin;
      inc(i);
      if result.cnNum > BIGLIMIT then
        BREAK;
    end;
    NextCycNum(result);
  until false;
  result.cnIdx := i;
end;

function FirstBlindPrimeCyclops(cnt:NativeInt):tCN;
var
  n: Uint64;
  i: NativeInt;
  isPr:Boolean;
begin
  i := 0;
  setlength(Cyclops,cnt);
  InitCycNum(result);
  while i< cnt do
  begin
    with result do
      if isPrime(cnNum) then
      Begin
        n:= cnRight.nmNum;
        if cndigits > 0 then
          n += cnLeft.nmNum*cnPow10Shift[cndigits-1]
        else
          n += cnLeft.nmNum*10;
        if isPrime(n) then
        Begin
          Cyclops[i] := cnNum;
          inc(i);
        end;
      end;
    NextCycNum(result);
  end;
  repeat
    with result do
      if isPrime(cnNum) then
      Begin
        n:= cnRight.nmNum;
        if cndigits > 0 then
          n += cnLeft.nmNum*cnPow10Shift[cndigits-1]
        else
          n += cnLeft.nmNum*10;
        isPr:= isPrime(n);
        inc(i,Ord(isPr));
        if isPr AND (cnNum > BIGLIMIT) then
          BREAK;
      end;
    NextCycNum(result);
  until false;
  result.cnIdx := i;
end;

function FirstPalinPrimeCyclops(cnt:NativeInt):tCN;
var
  i: NativeInt;
begin
  i := 0;
  setlength(Cyclops,cnt);
  InitCycNum(result);
  while i< cnt do
  Begin
    MakePalinCycNum(result);
    with result do
      if isPrime(cnNum) then
      Begin
        Cyclops[i] := cnNum;
        inc(i);
      end;
    IncLeftCn(result);
    while Not(result.cnLeft.nmdgts[result.cnDigits]+1 in [1,3,7,9]) do
      IncLeftCn(result);
  end;

  repeat
    MakePalinCycNum(result);
    with result do
      if isPrime(cnNum) then
      begin
        inc(i);
        if cnNum >BIGLIMIT then
          break;
      end;
      IncLeftCn(result);
      while Not(result.cnLeft.nmdgts[result.cnDigits]+1 in [1,3,7,9]) do
        IncLeftCn(result);
  until false;
  result.cnIdx := i;
end;

var
  cycnum:tCN;
  T0 : Int64;
  cnt : NativeUint;
begin
  InitCnMinPow;

  cnt := 50;
  writeln('The first ',cnt,' cyclops numbers are:');
  cycnum := FirstCyclops(cnt);
  Out_Cyclops(Cyclops,5,10);
  writeln('First such number > ',BIGLIMIT,' is ',cycnum.cnNum,
         ' at zero-based index ',cycnum.cnIdx);
  writeln;

  cnt := 50;
  writeln('The first ',cnt,' prime cyclops numbers are:');
  T0 := GetTickCount64;
  cycnum := FirstPrimeCyclops(cnt);
  T0 := GetTickCOunt64-T0;
  Out_Cyclops(Cyclops,7,10);
  writeln('First such number > ',BIGLIMIT,' is ',cycnum.cnNum,
         ' at one-based index ',cycnum.cnIdx);
  writeln(cycnum.cnIdx,'.th = ',cycnum.cnNum,' in  ',T0/1000:6:3,' s');
  writeln;

  cnt := 50;
  writeln('The first ',cnt,' blind prime cyclops numbers are:');
  T0 := GetTickCount64;
  cycnum := FirstBlindPrimeCyclops(cnt);
  T0 := GetTickCOunt64-T0;
  Out_Cyclops(Cyclops,7,10);
  writeln('First such number > ',BIGLIMIT,' is ',cycnum.cnNum,
         ' at one-based index ',cycnum.cnIdx);
  writeln(cycnum.cnIdx,'.th = ',cycnum.cnNum,' in  ',T0/1000:6:3,' s');
  writeln;

  cnt := 50;
  writeln('The first ',cnt,' palindromatic prime cyclops numbers are:');
  cycnum := FirstPalinPrimeCyclops(cnt);
  Out_Cyclops(Cyclops,15,5);
  writeln('First such number > ',BIGLIMIT,' is ',cycnum.cnNum,
       ' at one-based index ',cycnum.cnIdx);
  writeln;

  cnt := 100;
  repeat
    write(cnt:17,'.th = ');
    if cnt <= 10*1000 then
    Begin
      InitCycNum(cycnum);
      repeat
        NextCycNum(cycnum);
      until cycnum.cnIdx = cnt;
      write(cycnum.cnNum);
    end;
    cycnum:= IndexToCyclops(cnt);
    writeln(' calc ',cycnum.cnNum);
    cnt *= 10;
  until cnt >1000*1000*1000*1000*1000;
end.
