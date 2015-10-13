program prime;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,REGVAR,PEEPHOLE,CSE,ASMCSE}
  {$CODEALIGN proc=8}
//  {$R+,V+,O+}
{$ELSE}
  {$APPLICATION CONSOLE}
{$ENDIF}
uses
  sysutils;
type
  tSievenum      = NativeUint;
const
  cBitSize       = SizeOf(tSievenum)*8;
  cAndMask       = cBitSize-1;
  InitPrim      :array [0..9] of byte = (2,3,5,7,11,13,17,19,23,29);
(*
  {MAXANZAHL     =  2*3*5*7*11*13*17*19;*PRIM}
  MAXANZAHL     :array [0..8] of Longint =(2,6,30,210,2310,30030,
                                         510510,9699690,223092870);
  {WIFEMAXLAENGE =  1*2*4*6*10*12*16*18; *(PRIM-1)}
  WIFEMAXLAENGE :array [0..8] of longint =(1,2,8,48,480,5760,
                                         92160,1658880,36495360);
*)
//Don't sieve with primes that are multiples of 2..InitPrim[BIS]
  BIS           =     5;
  MaxMulFac     =    22; {array [0..9] of byte= (2,4,6,10,14,22,26,34,40,50);}
  cMaxZahl      = 30030;
  cRepFldLen    =  5760;

  MaxUpperLimit =  100*1000*1000*1000-1;

  MAXIMUM       = ((MaxUpperLimit-1) DIV cMaxZahl+1)*cMaxZahl;
  MAXSUCHE      = (((MAXIMUM-1) div cMaxZahl+1)*cRepFldLen-1)
                    DIV cBitSize;

type
  tRpFldIdx  = 0..cRepFldLen-1;
  pNativeUint = ^ NativeUint;
  (* numberField as Bit array *)
  tsearchFld   = array of tSievenum;

  tSegment       = record
                     dOfs,
                     dSegment    :tSievenum;
                  end;
  tpSegment     = ^tSegment;
  tMulFeld    = array [0..MaxMulFac shr 1 -1] of tSegment;
  tnumberField= array [0..cMaxZahl-1] of word; //word->  0..cRepFldLen-1
  tRevIdx     = array [tRpFldIdx] of word;//word->  0..cMaxZahl-1
  tDiffFeld   = array [tRpFldIdx] of byte;
  tNewPosFeld = array [tRpFldIdx] of Uint64;

  tRecPrime   = record
                  rpPrime,
                  rpsvPos : Uint64;
                  rpOfs,
                  rpSeg   :LongWord;
                end;

var
  BitSet,
  BitClr : Array [0..cAndMask] Of NativeUint;
  deltaNewPos : tNewPosFeld;
  MulFeld   : tMulFeld;
  searchFld : tsearchFld;
  number    : tnumberField;
  DiffFld   : tDiffFeld;
  RevIdx    : tRevIdx;
  actSquare   : Uint64;
  NewStartPos,
  MaxPos    : Uint64;

const
//K1  = $0101010101010101;
  K55 = $5555555555555555;
  K33 = $3333333333333333;
  KF1 = $0F0F0F0F0F0F0F0F;
  KF2 = $00FF00FF00FF00FF;
  KF4 = $0000FFFF0000FFFF;
  KF8 = $00000000FFFFFFFF;

function popcnt(n:Uint64):integer;overload;inline;
var
  c,b,k : NativeUint;
begin
  b := n;
  k := NativeUint(K55);c :=  (b shr  1) AND k; b := (b AND k)+C;
  k := NativeUint(K33);c := ((b shr  2) AND k);b := (b AND k)+C;
  k := NativeUint(KF1);c := ((b shr  4) AND k);b := (b AND k)+c;
  k := NativeUint(KF2);c := ((b shr  8) AND k);b := (b AND k)+c;
  k := NativeUint(KF4);c := ((b shr 16) AND k);b := (b AND k)+c;
  k := NativeUint(KF8);c :=  (b shr 32)+(b AND k);
  result := c;
end;

function popcnt(n:LongWord):integer;overload;
var
  c,k : LongWord;
begin
  result  := n;
  IF result = 0 then
    EXIT;
  k := LongWord(K55);c :=  (result  shr  1) AND k; result  := (result  AND k)+C;
  k := LongWord(K33);c := ((result  shr  2) AND k);result  := (result  AND k)+C;
  k := LongWord(KF1);c := ((result  shr  4) AND k);result  := (result  AND k)+c;
  k := LongWord(KF2);c := ((result  shr  8) AND k);result  := (result  AND k)+c;
  k := LongWord(KF4);
  result :=  (result  shr 16) AND k +(result  AND k);
end;

procedure Init;
{simple sieve of erathosthenes only eliminating small primes}
var
  pr,i,j,Ofs : NativeUint;
Begin
  //Init Bitmasks
  j := 1;
  For i := 0 to cAndMask do
  Begin
    BitSet[i] := J;
    BitClr[i] := NativeUint(NOT(J));
    j:= j+j;
  end;
  //building number wheel excluding multiples of small primes
  Fillchar(number,SizeOf(number),#0);
  For i := 0 to BIS do
  Begin
    pr := InitPrim[i];
    j := (High(number) div pr)*pr;
    repeat
      number[j] := 1;
      dec(j,pr);
    until j <= 0;
  end;

  // build reverse Index and save distances
  i := 1;
  j := 0;
  RevIdx[0]:= 1;
  repeat
    Ofs :=0;
    repeat
      inc(i);
      inc(ofs);
    until number[i] = 0;
    DiffFld[j] := ofs;
    inc(j);
    RevIdx[j] := i;
  until i = High(number);
  DiffFld[j] := 2;

  //calculate a bitnumber-index into cRepFldLen
  Fillchar(number,SizeOf(number),#0);
  Ofs := 1;
  for i := 0 to cRepFldLen-2 do
  begin
    inc(Ofs,DiffFld[i]);
    number[ofs] := i+1;
  end;

  //direct index into Mulfeld 2->0 ,4-> 1 ...
  For i := 0 to cRepFldLen-1 do
  Begin
    j := (DiffFld[i] shr 1) -1;
    DiffFld[i] := j;
  end;
end;

function CalcPos(m: Uint64): Uint64;
{search right position of m}
var
  i,res : NativeUint;
Begin
  res := m div cMaxZahl;
  i   := m-res* Uint64(cMaxzahl);//m mod cMaxZahl
  while (number[i]= 0) and (i <>1) do
  begin
    iF i = 0 THEN
    begin
      Dec(res,cRepFldLen);
      i := cMaxzahl;
    end;
    dec(i);
  end; {while}
  CalcPos := res *Uint64(cRepFldLen) +number[i];
end;

procedure CalcSqrOfs(out Segment,Ofs :Uint64);
Begin
  Segment  := actSquare div cMaxZahl;
  Ofs      := actSquare-Segment*cMaxZahl; //ofs Mod cMaxZahl
  Segment  := Segment*cRepFldLen;
end;

procedure MulTab(sievePr:Nativeint);
var
 k,Segment,Segment0,Rest,Rest0: NativeUint;
Begin
  {multiplication-table of differences}
  {2* sievePr,4* ,6* ...MaxMulFac*sievePr }
  sievePr := sievePr+sievePr;
  Segment0 := sievePr div cMaxzahl;

  Rest0    := sievePr-Segment0*cMaxzahl;
  Segment0 := Segment0 * cRepFldLen;

  Segment := Segment0;
  Rest := Rest0;

  with MulFeld[0] do
  begin
    dOfs := Rest0;
    dSegment:= Segment0;
  end;

  for k := 1 to MaxMulFac shr 1-1 do
  begin
    Segment := Segment+Segment0;
    Rest    := Rest+Rest0;
    IF Rest >= cMaxzahl then
    Begin
      Rest:= Rest-cMaxzahl;
      Segment := Segment+cRepFldLen;
    end;
    with MulFeld[k] do
    begin
      dOfs := Rest;
      dSegment:= Segment;
    end;
  end;
end;

procedure CalcDeltaNewPos(sievePr,MulPos:NativeUint);
var
  Ofs,Segment,prevPos,actPos : Uint64;
  i: NativeInt;
Begin
  MulTab(sievePr);
  //start at sqr sievePrime
  CalcSqrOfs(Segment,Ofs);
  NewStartPos := Segment+number[Ofs];
  prevPos := NewStartPos;
  deltaNewPos[0]:= prevPos;
  For i := 0 to cRepFldLen-2 do
  begin
    inc(mulpos);
    IF mulpos >= cRepFldLen then
      mulpos := 0;
    With MulFeld[DiffFld[mulpos]] do
    begin
      Ofs:= Ofs+dOfs;
      Segment := Segment+dSegment;
    end;
    If Ofs >= cMaxZahl then
    begin
      Ofs := Ofs-cMaxZahl;
      Segment := Segment+cRepFldLen;
    end;
    actPos := Segment+number[Ofs];
    deltaNewPos[i]:= actPos - prevPos;
    IF actPos> maxPos then
      BREAK;

    prevPos := actPos;
  end;
  deltaNewPos[cRepFldLen-1] := NewStartPos+cRepFldLen*sievePr-prevPos;
end;

procedure SieveByOnePrime(var sf:tsearchFld;sievePr:NativeUint);
var
  pNewPos : ^Uint64;
  pSiev0,
  pSiev   : ^tSievenum;// dynamic arrays are slow
  Ofs      : Int64;
  Position : UINt64;
  i: NativeInt;

Begin
  pSiev0 := @sf[0];
  Ofs := MaxPos-sievePr *cRepFldLen;
  Position := NewStartPos;
  {unmark multiples of sieve prime}
  repeat
    IF Position < Ofs then
    Begin
      pNewPos:= @deltaNewPos[0];
      For i := Low(deltaNewPos) to High(deltaNewPos) do
      Begin
        pSiev := pSiev0;
        inc(pSiev,Position DIV cBitSize);
        //pSiev^ == @sf[Position DIV cBitSize]
        pSiev^ := pSiev^ AND BitCLR[Position AND cAndMask];
        inc(Position,pNewPos^);
        inc(pNewPos);
      end
    end
    else
    Begin
      pNewPos:= @deltaNewPos[0];
      For i := Low(deltaNewPos) to High(deltaNewPos) do
      Begin
        IF Position >= MaxPos then
          Break;
        pSiev := pSiev0;
        inc(pSiev,Position DIV cBitSize);
        pSiev^ := pSiev^ AND BitCLR[Position AND cAndMask];
        inc(Position,pNewPos^);
        inc(pNewPos);
      end
    end;
  until Position >= MaxPos;
end;

procedure SieveAll;
var
  i,
  sievePr,
  PrimPos,
  srPrPos  : NativeUint;
  l:   Uint64;
Begin
  Init;
  MaxPos := CalcPos(MaxUpperLimit);
  {start of prime sieving}
  i := (MaxPos-1) DIV cBitSize+1;
  setlength(searchFld,i);
  IF Length(searchFld) <> i then
  Begin
    writeln('Not enough memory');
    Halt(-227);
  end;
  For i := High(searchFld) downto 0 do
     searchFld[i] := NativeUint(-1);
  {the first prime}
  srPrPos := 0;
  PrimPos := 0;
  sievePr := 1;
  actSquare := sievePr;
  repeat
    {next prime}
    inc(srPrPos);
    i := 2*(DiffFld[PrimPos]+1);
    //binom (a+b)^2; a^2 already known
    actSquare := actSquare+(2*sievePr+i)*i;
    inc(sievePr,i);

    IF actSquare > MaxUpperLimit THEN
      BREAK;
    {if sievePr == prime then sieve with sievePr}
    if BitSet[srPrPos AND cAndMask] AND
      searchFld[srPrPos DIV cBitSize] <> 0then
    Begin
      write(sievePr:8,#8#8#8#8#8#8#8#8);
      CalcDeltaNewPos(sievePr,PrimPos);
      SieveByOnePrime(searchFld,sievePr);
    end;
    inc(PrimPos);
    if PrimPos = cRepFldLen then
      dec(PrimPos,PrimPos);// := 0;
  until false;
end;

function InitRecPrime(pr: UInt64):tRecPrime;
var
  svPos,sg : NativeUint;
Begin
  svPos := CalcPos(pr);
  sg := svPos DIV cRepFldLen;
  with result do
  Begin
    rpsvPos := svPos;
    rpSeg   := sg;
    rpOfs   := svPos - sg*cRepFldLen;
    rpPrime := RevIdx[rpOfs]+ sg*cMaxZahl;
  end;
end;

function InitPrimeSvPos(svPos: Uint64):tRecPrime;
var
  sg : LongWord;
Begin
  sg := svPos DIV cRepFldLen;
  with result do
  Begin
    rpsvPos := svPos;
    rpSeg   := sg;
    rpOfs   := svPos - sg*cRepFldLen;
    rpPrime := RevIdx[rpOfs]+ sg*cMaxZahl;
  end;
end;

function NextPrime(var pr:  tRecPrime):Boolean;
var
  ofs : LongWord;
  svPos : Uint64;
Begin
  with pr do
  Begin
    svPos := rpsvPos;
    Ofs := rpOfs;
    repeat
      inc(svPos);
      if svPos > MaxPos then
      Begin
        result := false;
        EXIT;
      end;
      inc(Ofs);
      IF Ofs >= cRepFldLen then
      Begin
        ofs := 0;
        inc(rpSeg);
      end;
    until BitSet[svPos AND cAndMask] AND
      searchFld[svPos DIV cBitSize] <> 0;
    rpPrime := rpSeg*Uint64(cMaxZahl)+RevIdx[Ofs];
    rpSvPos := svPos;
    rpOfs := Ofs;
  end;
  result := true;
end;

function GetNthPrime(n: Uint64):tRecPrime;
var
  i : longWord;
  cnt: Uint64;
Begin
  IF n > MaxPos then
    EXIT;

  i := 0;
  cnt := Bis;
  For i := 0 to n DIV cBitSize do
    inc(cnt,PopCnt(NativeUint(searchFld[i])));
  i := n DIV cBitSize+1;

  while cnt < n do
  Begin
    inc(cnt,PopCnt(NativeUint(searchFld[i])));
    inc(i);
  end;
  dec(i);

  dec(cnt,PopCnt(NativeUint(searchFld[i])));
  result := InitPrimeSvPos(i*Uint64(cBitSize)-1);
  while cnt < n do
    IF NextPrime(Result) then
      inc(cnt)
    else
      Break;
end;

procedure ShowPrimes(loLmt,HiLmt: NativeInt);
var
  p1 :tRecPrime;
Begin
  IF HiLmt < loLmt then
    exit;
  p1 := InitRecPrime(loLmt);
  while p1.rpPrime < LoLmt do
    IF Not(NextPrime(p1)) Then
      EXIT;

  repeat
    write(p1.rpPrime,' ');
    IF Not(NextPrime(p1)) Then
      Break;
  until p1.rpPrime > HiLmt;
  writeln;
end;

function CountPrimes(loLmt,HiLmt: NativeInt):LongWord;
var
  p1 :tRecPrime;
Begin
  result := 0;
  IF HiLmt < loLmt then
    exit;
  p1 := InitRecPrime(loLmt);
  while p1.rpPrime < LoLmt do
    IF Not(NextPrime(p1)) Then
      EXIT;
  repeat
    inc(result);
    IF Not(NextPrime(p1)) Then
      Break;
  until p1.rpPrime > HiLmt;
end;

procedure WriteCntSmallPrimes(n: NativeInt);
var
  i, p,prPos,svPos : nativeUint;
Begin
  dec(n);
  IF n < 0 then
    EXIT;
  write('First ',n+1,' primes ');
  IF n < Bis then
  Begin
    For i := 0 to n do
      write(InitPrim[i]:3);
  end
  else
  Begin
    For i := 0 to BIS do
      write(InitPrim[i],' ');
    dec(n,Bis);

    svPos := 0;
    PrPos := 0;
    p     := 1;
    while n> 0 do
    Begin
      {next prime}
      inc(svPos);
      inc(p,2*(DiffFld[prPos]+1));
      if BitSet[svPos AND cAndMask] AND searchFld[svPos DIV cBitSize] <>0 then
      Begin
        write(p,' ');
        dec(n);
      end;
      inc(prPos);
      if prPos = cRepFldLen then
        dec(prPos,prPos);// := 0;
    end;
  end;
  writeln;
end;

function RvsNumL(var n: Uint64):Uint64;
//reverse and last digit, most of the time n > base therefor repeat
const
  base = 10;
var
  q, c: Int64;
Begin
  result := n;
  q := 0;
  repeat
    c:= result div Base;
    q := result+ (q-c)*Base;
    result := c;
  until result < Base;
  n := q*Base+result;
end;

function IsEmirp(n:Uint64):boolean;
var
 lastDgt:NativeUint;
 ofs: NativeUint;
 seg : Uint64;
Begin
  seg := n;
  lastDgt:= RvsNumL(n);
  result:= false;
  IF (seg = n) OR (n> MaxUpperLimit) then
    EXIT;

  IF lastDgt in [1,3,7,9] then
  Begin
    seg := n div cMaxZahl;
    ofs := n-seg* cMaxzahl;//m mod cMaxZahl
    IF (Number[ofs] <> 0) OR (ofs=1) then
    begin
      seg := seg *cRepFldLen+number[ofs];
      result := BitSet[seg AND cAndMask]  AND searchFld[seg DIV cBitSize] <> 0;
    end
  end;
end;

procedure GetEmirps(loLmt,HiLmt: Uint64);
var
  p1 :tRecPrime;
  cnt: NativeUint;
Begin
  cnt := 0;
  IF HiLmt < loLmt then
    exit;
  IF loLmt > MaxUpperLimit then
    Exit;
  IF HiLmt > MaxUpperLimit then
    HiLmt := MaxUpperLimit;

  p1 := InitRecPrime(loLmt);
  while p1.rpPrime < LoLmt do
    IF Not(NextPrime(p1)) Then
      EXIT;

  repeat
    if isEmirp(p1.rpPrime) then
      inc(cnt);
    iF not(NextPrime(p1)) then
      BREAK;
  until p1.rpPrime > HiLmt;

  write(cnt:10);
end;

var
  T1,T0: TDateTime;
  Anzahl :Uint64;
  i,j : Uint64;
  n : LongInt;
Begin
  T0 := now;
  SieveAll;
  T1 := now;
  writeln('         ');
  Writeln('time for sieving ',FormatDateTime('NN:SS.ZZZ',T1-T0));
  Anzahl := BIS;
  For n := MaxPos DIV cBitSize-1 downto 0 do
    inc(Anzahl,PopCnt(NativeUint(searchFld[n])));
  n := MaxPos AND cAndMask;
  IF n >0 then
  Begin
    dec(n);
    repeat
      IF BitSet[n] AND searchFld[MaxPos DIV cBitSize] <> 0 then
        inc(Anzahl);
      dec(n);
    until n< 0;
  end;

  Writeln('there are ',Anzahl,' primes til ',MaxUpperLimit);
  WriteCntSmallPrimes(20);
  write('primes between 100 and 150: ');
  ShowPrimes(100,150);
  write('count of primes between 7700 and 8000 ');
  Writeln(CountPrimes(7700,8000));
  i := 100;
  repeat
    Writeln('the ',i, ' th prime ',GetNthPrime(i).rpPrime);
    i := i * 10;
  until i*25 > MaxUpperLimit;

  writeln;
  writeln('Count Emirps');
  j := 10;
  repeat
   writeln(j:10);
    GetEmirps(  j,  j+j-1);//10..00->19..99
    GetEmirps(3*j,3*j+j-1);//30..00->39..99
    GetEmirps(7*j,7*j+j-1);//70..00->79..99
    GetEmirps(9*j,9*j+j-1);//90..00->99..99
    writeln;
    j:=j*10;
  until j >= MaxUpperLimit;

end.
