program prime7;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,REGVAR,PEEPHOLE,CSE,ASMCSE}
  {$Smartlink ON}
  {$CODEALIGN proc=32}
{$ELSE}
  {$APPLICATION CONSOLE}
{$ENDIF}
uses
  popcount;
const

  InitPrim      :array [0..9] of byte = (2,3,5,7,11,13,17,19,23,29);
(*
  {MAXANZAHL     =  2*3*5*7*11*13*17*19;*PRIM}
  MAXANZAHL     :array [0..8] of Longint =(2,6,30,210,2310,30030,
                                         510510,9699690,223092870);
  {WIFEMAXLAENGE =  1*2*4*6*10*12*16*18;*PRIM-1}
  WIFEMAXLAENGE :array [0..8] of longint =(1,2,8,48,480,5760,
                                         92160,1658880,36495360);
*)
  BIS           =    4;
  cMaxZahl      = 2310;
  cRepFldLen    =  480;

{Sieve results:
 one billion   --  50,847,534
 two billion   --  98,222,287
 three billion -- 144,449,537
 four billion  -- 189,961,812
 ten  billion  -- 455.052.511
 }
  MaxZahl       =  20*1000*1000;
  //limit for 32 Bit calc   tSievenum      = LongWord; 20e9
  //MaxZahl        = High(LongWord) DIV cRepFldLen *cMaxZahl;
  MAXIMUM       = ((MaxZahl-1) DIV cMaxZahl+1)*cMaxZahl;
                   // maximal distance  in number wheel
  MaxMulFac  = 14; {array [0..9] of byte= (2,4,6,10,14,22,26,34,40,50);}
                   {Auf  Mod 32 = 0 bringen}
 {MAXSUCHE      = MAXIMUM*WIFEMAXLAENGE[BIS]/MAXANZAHl[BIS]}
(* div2,div3,*4div15,*8div35,*16div77,*192 div 1001,*3072div17017.. *)
  MAXSUCHE      = ((((MAXIMUM-1) div cMaxZahl+1)*cRepFldLen-1)shr 5+1)shl 5;


type
  tSievenum      = Uint32;// Uint64 doubles run-time in 32 Bit
  tSegment       = record
                     dOfs,
                     dSegment    :LongWord;
                  end;
  tpSegment     = ^tSegment;
  tMulFeld    = array [0..MaxMulFac shr 1 -1] of tSegment;
  tnumberField= array [0..cMaxZahl-1] of Word;
  tDiffFeld   = array [0..{WIFEMAXLAENGE[BIS]}cRepFldLen-1] of byte;
  tRevIdx     = array [0..{WIFEMAXLAENGE[BIS]}cRepFldLen-1] of word;
  (* numberField as Bit array *)
  tsearchFld   = array [0..MAXSUCHE shr 5-1] of set of 0..31;

  tRecPrime   = record
                  rpPrime :tSievenum;
                  rpsvPos,
                  rpOfs,
                  rpSeg   :LongWord;
                end;

var
  MulFeld   : tMulFeld;
  searchFld : tsearchFld;
  number    : tnumberField;
  DiffFld   : tDiffFeld;
  RevIdx    : tRevIdx;
  Quadrat   : Uint64;
  MaxPos    : NativeUint;

const
  two : Array [0..31] Of LongWord = (
        $00000001 , $00000002 , $00000004 , $00000008
      , $00000010 , $00000020 , $00000040 , $00000080
      , $00000100 , $00000200 , $00000400 , $00000800
      , $00001000 , $00002000 , $00004000 , $00008000
      , $00010000 , $00020000 , $00040000 , $00080000
      , $00100000 , $00200000 , $00400000 , $00800000
      , $01000000 , $02000000 , $04000000 , $08000000
      , $10000000 , $20000000 , $40000000 , $80000000
      ) ;

procedure BuildWheel;
{simple sieve of erathothenes only eliminating small primes}
var
  pr,i,j,Ofs : NativeUint;
Begin
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
    number[Ofs] := i+1;
  end;

  For i := 0 to cRepFldLen-1 do
  Begin
    //direct index to Mulfeld
    j := (DiffFld[i] shr 1) -1;
    DiffFld[i] := j;
  end;
end;

function CalcPos(m: Uint64): UINt32;
{search right position of m}
var
  i,res : Uint32;
Begin
  res := m div cMaxZahl;
  i   := m mod cMaxzahl;
  while (number[i]= 0) and (i <>1) do
  begin
    iF i = 0 THEN
    begin
      Dec(res,cRepFldLen);
      i := cMaxzahl;
    end;
    dec(i);
  end; {while}
  CalcPos := res *cRepFldLen +number[i];
end;

procedure MulTab(searchPr:Nativeint);
var
 k,Segment,Segment0,Rest,Rest0: NativeUint;
Begin
  {Multiplikationstabelle der Differenzen}
  searchPr := searchPr+searchPr;
  Segment0 := searchPr div cMaxzahl;

  Rest0    := searchPr-Segment0*cMaxzahl;
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

procedure CalcSqrOfs(searchPr:NativeUint;out
                     Segment,Ofs :tSievenum);
Begin
  Segment  := Quadrat div cMaxZahl;
  Ofs      := Quadrat-Uint64(Segment)*cMaxZahl; //ofs Mod cMaxZahl
  Segment  := Segment*cRepFldLen;
end;

procedure Sieben(var sf:tsearchFld;searchPr,MulPos:NativeUint);
//for big sieve  Segment,Position,k need to be Uint64
var
  Ofs,Segment,Position,k : tSievenum;//NativeUint;
  p : pLongWord;
Begin
  MulTab(searchPr);
  CalcSqrOfs(searchPr,Segment,Ofs);
  Position := Segment+number[ofs];

  {Primzahlen ausstreichen}
  repeat
    k:= MulPos+1;
    IF k >= cRepFldLen then
      dec(k,k);//=0;
    mulpos := k;
    k := DiffFld[k];
    With MulFeld[k] do
    begin
      k:= Ofs+dOfs;
      Segment := Segment+dSegment;
    end;

    If k >= cMaxZahl then
    begin
      k := k-cMaxZahl;
      Segment := Segment+cRepFldLen;
    end;
    Ofs := k;
    k := Segment+number[k];
    p := @sf[Position shr 5];
//   exclude(searchFld[Position shr 5],Position and 31);
    p^ := p^ OR two[Position and 31];
    IF k > Position then
      Position := k//number[Ofs]+Segment;
    else
      //case of overflow try 2E10 with 32-Bit
      Break;
  until Position >= MaxPos;
end;

procedure SieveAll;
var
  i,
  searchPr,
  PrimPos,
  srPrPos  : NativeUint;
Begin
  BuildWheel;
  MaxPos := CalcPos(MaxZahl);
  {start of prime sieving}
  fillchar(searchFld,SizeOf(searchFld),#0);
  {the first prime}
  srPrPos := 0;
  PrimPos := 0;
  searchPr := 1;
  Quadrat := searchPr;
  repeat
    {next prime}
    inc(srPrPos);
    i := 2*(DiffFld[PrimPos]+1);
    //binom (a+b)^2; a^2 already known
    Quadrat := Quadrat+(2*searchPr+i)*i;
    inc(searchPr,i);
    IF Quadrat > MAXIMUM THEN
      BREAK;
    {if searchPr == prime then sieve with searchPr}
    if NOT((srPrPos and 31) in searchFld[srPrPos shr 5] )then
      Sieben(searchFld,searchPr,PrimPos);
    inc(PrimPos);
    if PrimPos = cRepFldLen then
      dec(PrimPos,PrimPos);// := 0;
  until false;
end;

function InitRecPrime(pr: tSievenum):tRecPrime;
var
  svPos,sg : LongWord;
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

function InitPrimeSvPos(svPos: LongWord):tRecPrime;
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

Procedure NextPrime(var pr:  tRecPrime);
var
  ofs,svPos : LongWord;
Begin
  with pr do
  Begin
    svPos := rpsvPos;
    Ofs := rpOfs;
    repeat
      inc(svPos);
      if svPos > MaxPos then
        EXIT;
      inc(Ofs);
      IF Ofs >= cRepFldLen then
      Begin
        ofs := 0;
        inc(rpSeg,cRepFldLen);
      end;
    until NOT((svPos and 31) in searchFld[svPos shr 5] );
    rpPrime := rpSeg*cMaxZahl+RevIdx[Ofs];
    rpSvPos := svPos;
    rpOfs := Ofs;
  end;
end;

function GetNthPrime(n: LongWord):tRecPrime;
var
  i,cnt : longWord;
Begin
  IF n > MaxPos then
    EXIT;

  i := 0;
  cnt := Bis;
  For i := 0 to n shr 5 do
    inc(cnt,PopCnt(NOT(Uint32(searchFld[i]))));
  i := n shr 5+1;
  while cnt < n do
  Begin
    inc(cnt,PopCnt(NOT(Uint32(searchFld[i]))));
    inc(i);
  end;
  dec(i);
  dec(cnt,PopCnt(NOT(Uint32(searchFld[i]))));
  result := InitPrimeSvPos(i*32-1);
  while cnt < n do
  Begin
    NextPrime(Result);
    inc(cnt);
  end;
end;

procedure ShowPrimes(loLmt,HiLmt: NativeInt);
var
  p1 :tRecPrime;
Begin
  IF HiLmt < loLmt then
    exit;
  p1 := InitRecPrime(loLmt);
  while p1.rpPrime < LoLmt do
    NextPrime(p1);
  repeat
    write(p1.rpPrime,' ');
    NextPrime(p1);
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
    NextPrime(p1);
  repeat
    inc(result);
    NextPrime(p1);
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
      if NOT((svPos and 31) in searchFld[svPos shr 5] )then
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

var
  Anzahl :Uint64;
  i : NativeUint;
Begin
  SieveAll;

  i := 0;
  Anzahl := BIS+1;
  //MaxPos = res *cRepFldLen +number[i];
  For i := 0 to MaxPos shr 5-1 do
    inc(Anzahl,PopCnt(NOT(Uint32(searchFld[i]))));
  i := MaxPos AND 31;
  dec(i);
  while i>0 do
  Begin
    IF Not(i in searchFld[MaxPos shr 5]) then
      inc(Anzahl);
    dec(i);
  end;
//  Writeln('Bis ',MaxZahl,' sind es ',Anzahl,' Primzahlen');
  WriteCntSmallPrimes(20);
  write('Primes between 100 and 150: ');
  ShowPrimes(100,150);
  write('Number of primes between 7700 and 8000 ');
  Writeln(CountPrimes(7700,8000));
  i := 100;
  repeat
    Writeln('the ',i, ' th prime ',GetNthPrime(i).rpPrime);
    i := i * 10;
  until i> 1000000;
end.
