program Giuga;
{
30 = 2 * 3 * 5.
858 = 2 * 3 * 11 * 13.
1722 = 2 * 3 * 7 * 41.
66198 = 2 * 3 * 11 * 17 * 59.
2214408306 = 2 * 3 * 11 * 23 * 31 * 47057.
24423128562 = 2 * 3 * 7 * 43 * 3041 * 4447.
432749205173838 = 2 * 3 * 7 * 59 * 163 * 1381 * 775807.
14737133470010574 = 2 * 3 * 7 * 71 * 103 * 67213 * 713863.
550843391309130318 = 2 * 3 * 7 * 71 * 103 * 61559 * 29133437.
244197000982499715087866346 = 2 * 3 * 11 * 23 * 31 * 47137 * 28282147 * 3892535183.
554079914617070801288578559178 = 2 * 3 * 11 * 23 * 31 * 47059 * 2259696349 * 110725121051.
1910667181420507984555759916338506 = 2 * 3 * 7 * 43 * 1831 * 138683 * 2861051 * 1456230512169437. }
{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
const
  LMT =14737133470010574;// 432749205173838;//24423128562;//2214408306;
type
  tFac = packed record
                 fMul     :Uint64;
                 fPrime,
                 fPrimIdx,
                 fprimMaxIdx,dummy :Uint32;
                 dummy2: Uint64;
               end;
  tFacs  = array[0..15] of tFac;
  tPrimes = array[0..62157] of Uint32;//775807 see factor of 432749205173838
//  tPrimes = array[0..4875{14379}] of Uint32;//sqrt 24423128562
//  tPrimes = array[0..1807414] of Uint32;//29133437
//  tPrimes = array[0..50847533] of Uint32;// 1e9
//  tPrimes = array[0..5761454] of Uint32;//1e8
var
  SmallPrimes: tPrimes;
  T0 : Int64;
  cnt:Uint32;

procedure InitSmallPrimes;
//get primes. #0..65535.Sieving only odd numbers
const
  //MAXLIMIT = (trunc(sqrt(LMT)+1)-1) shr 1+4;
  MAXLIMIT = 775807 DIV 2+1;//(trunc(sqrt(LMT)+1)-1) shr 1+4;
var
  pr : array of byte;
  pPr :pByte;
  p,j,d,flipflop :NativeUInt;
Begin
  SmallPrimes[0] := 2;
  setlength(pr,MAXLIMIT);
  pPr := @pr[0];
  p := 0;
  repeat
    repeat
      p +=1
    until pPr[p]= 0;
    j := (p+1)*p*2;
    if j>MAXLIMIT then
      BREAK;
    d := 2*p+1;
    repeat
      pPr[j] := 1;
      j += d;
    until j>MAXLIMIT;
  until false;

  SmallPrimes[1] := 3;
  SmallPrimes[2] := 5;
  j := 3;
  d := 7;
  flipflop := (2+1)-1;//7+2*2,11+2*1,13,17,19,23
  p := 3;
  repeat
    if pPr[p] = 0 then
    begin
      SmallPrimes[j] := d;
      inc(j);
    end;
    d += 2*flipflop;
    p+=flipflop;
    flipflop := 3-flipflop;
  until (p > MAXLIMIT) OR (j>High(SmallPrimes));
  setlength(pr,0);
end;

procedure OutFac(var F:tFacs;maxIdx:Uint32);
var
  i : integer;
begin
  write(cnt:3,'  ');
  For i := 0 to maxIdx do
    write(F[i].fPrime,'*');
  write(#8,' = ',F[maxIdx].fMul);
  writeln('      ',(GetTickCount64-T0)/1000:10:3,' s');
  //readln;
end;

function ChkGiuga(var F:tFacs;MaxIdx:Uint32):boolean;inline;
var
  n : Uint64;
  idx: NativeInt;
  p : Uint32;
begin
  n := F[MaxIdx].fMul;
  idx := MaxIdx;
  repeat
    p := F[idx].fPrime;
    result := (((n DIV p)-1)MOD p) = 0;
    if not(result) then
      EXIT;
    dec(idx);
  until idx<0;
  inc(cnt);
end;

procedure InsertNextPrimeFac(var F:tFacs;idx:Uint32);
var
  Mul : Uint64;
  i,p : uint32;
begin
  with F[idx-1] do
  begin
    Mul := fMul;
    i := fPrimIdx;
  end;

  while i<High(SmallPrimes) do
  begin
    inc(i);
    with F[idx] do
    begin
      if i >fprimMaxIdx then
        BREAK;
      p := SmallPrimes[i];
      if p*Mul>LMT then
        BREAK;
      fMul := p*Mul;
      fPrime := p;
      fPrimIdx := i;
      IF (Mul-1) MOD p = 0 then
        IF ChkGiuga(F,idx) then
          OutFac(F,idx);
    end;
// max 6 factors //for lmt 24e9 need 7 factors
    if idx <5 then
      InsertNextPrimeFac(F,idx+1);
  end;
end;

var
  {$ALIGN 32}
  Facs : tFacs;
  i : integer;
Begin
  InitSmallPrimes;

  T0 := GetTickCount64;
  with Facs[0] do
  begin
    fMul := 2;fPrime := 2;fPrimIdx:= 0;
  end;
  with Facs[1] do
  begin
    fMul := 2*3;fPrime := 3;fPrimIdx:= 1;
  end;
  i := 2;
  //search the indices of mx found factor
  while SmallPrimes[i] < 11 do inc(i); Facs[2].fprimMaxIdx := i;
  while SmallPrimes[i] < 71 do inc(i); Facs[3].fprimMaxIdx := i;
  while SmallPrimes[i] < 3041 do inc(i); Facs[4].fprimMaxIdx := i;
  while SmallPrimes[i] < 67213 do inc(i); Facs[5].fprimMaxIdx := i;
  while SmallPrimes[i] < 775807 do inc(i); Facs[6].fprimMaxIdx := i;
{
  writeln('Found ',cnt,' in ',(GetTickCount64-T0)/1000:10:3,' s');
  //start with 2*3*7
  with Facs[2] do
  begin
    fMul := 2*3*7;fPrime := 7;fPrimIdx:= 3;
  end;
  InsertNextPrimeFac(Facs,3);
  //start with 2*3*11
  writeln('Found ',cnt,' in ',(GetTickCount64-T0)/1000:10:3,' s');
  with Facs[2] do
  begin
    fMul := 2*3*11;fPrime := 11;fPrimIdx:= 4;
  end;
  InsertNextPrimeFac(Facs,3);
}
  InsertNextPrimeFac(Facs,2);
  writeln('Found ',cnt,' in ',(GetTickCount64-T0)/1000:10:3,' s');
  writeln;
end.
