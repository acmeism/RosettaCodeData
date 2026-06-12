program CubeFree2;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,ALL}
//{$CODEALIGN proc=16,loop=8} //TIO.RUN (Intel Xeon 2.3 Ghz) loves it
  {$COPERATORS ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
const
  SizeCube235 =4* (2*2*2* 3*3*3 *5*5*5);//2*27000 <= 64kb level I
type
  tPrimeIdx = 0..65535;
  tPrimes = array[tPrimeIdx] of Uint32;
  tSv235IDx = 0..SizeCube235-1;
  tSieve235 = array[tSv235IDx] of boolean;
  tDl3 = record
               dlPr3 : UInt64;
               dlSivMod,
               dlSivNum : Uint32;
            end;
  tDelCube = array[tPrimeIdx] of tDl3;

var
  {$ALIGN 8}
  SmallPrimes: tPrimes;
  Sieve235,
  Sieve : tSieve235;
  DelCube : tDelCube;

procedure InitSmallPrimes;
//get primes. #0..65535.Sieving only odd numbers
const
  MAXLIMIT = (821641-1) shr 1;
var
  pr : array[0..MAXLIMIT] of byte;
  p,j,d,flipflop :NativeUInt;
Begin
  SmallPrimes[0] := 2;
  fillchar(pr[0],SizeOf(pr),#0);
  p := 0;
  repeat
    repeat
      p +=1
    until pr[p]= 0;
    j := (p+1)*p*2;
    if j>MAXLIMIT then
      BREAK;
    d := 2*p+1;
    repeat
      pr[j] := 1;
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
    if pr[p] = 0 then
    begin
      SmallPrimes[j] := d;
      inc(j);
    end;
    d += 2*flipflop;
    p+=flipflop;
    flipflop := 3-flipflop;
  until (p > MAXLIMIT) OR (j>High(SmallPrimes));
end;

procedure Init235(var Sieve235:tSieve235);
var
  i,j,k : NativeInt;
begin
  fillchar(Sieve235,SizeOf(Sieve235),Ord(true));
  Sieve235[0] := false;
  for k in [2,3,5] do
  Begin
    j := k*k*k;
    i := j;
    while i < SizeCube235 do
    begin
      Sieve235[i] := false;
      inc(i,j);
    end;
  end;
end;

procedure InitDelCube(var DC:tDelCube);
var
  i,q,r : Uint64;
begin
  for i in tPrimeIdx do
  begin
    q := SmallPrimes[i];
    q *= sqr(q);
    with DC[i] do
    begin
      dlPr3 := q;
      r := q div SizeCube235;
      dlSivNum := r;
      dlSivMod := q-r*SizeCube235;
    end;
  end;
end;
function Numb2USA(n:Uint64):Ansistring;
var
  pI :pChar;
  i,j : NativeInt;
Begin
  str(n,result);
  i := length(result);
 //extend s by the count of comma to be inserted
  j := i+ (i-1) div 3;
  if i<> j then
  Begin
    setlength(result,j);
    pI := @result[1];
    dec(pI);
    while i > 3 do
    Begin
       //copy 3 digits
       pI[j] := pI[i];pI[j-1] := pI[i-1];pI[j-2] := pI[i-2];
       // insert comma
       pI[j-3] := ',';
       dec(i,3);
       dec(j,4);
    end;
  end;
end;

function highestDiv(n: uint64):Uint64;
//can test til 821641^2 ~ 6,75E11
var
  pr : Uint64;
  i : integer;
begin
  result := n;
  i := 0;
  repeat
    pr := Smallprimes[i];
    if pr*pr>result then
      BREAK;
    while (result > pr) AND (result MOD pr = 0) do
      result := result DIV pr;
    inc(i);
  until i > High(SmallPrimes);
end;

procedure OutNum(lmt,n:Uint64);
begin
  writeln(Numb2Usa(lmt):18,Numb2Usa(n):19,Numb2Usa(highestDiv(n)):18);
end;


var
  sieveNr,minIdx,maxIdx : Uint32;
procedure SieveOneSieve;
var
  j : Uint64;
  i : Uint32;
begin
 // sieve with previous primes
  Sieve := Sieve235;
  For i := minIdx to MaxIdx do
    with DelCube[i] do
      if dlSivNum = sievenr then
      begin
        j :=  dlSivMod;
        repeat
          sieve[j] := false;
          inc(j,dlPr3);
        until j >= SizeCube235;
        dlSivMod := j Mod SizeCube235;
        dlSivNum += j div SizeCube235;
      end;
  //sieve with new primes
  while DelCube[maxIdx+1].dlSivNum = sieveNr do
  begin
    inc(maxIdx);
    with DelCube[maxIdx] do
    begin
      j :=  dlSivMod;
      repeat
        sieve[j] := false;
        inc(j,dlPr3);
      until j >= SizeCube235;
      dlSivMod := j Mod SizeCube235;
      dlSivNum := sieveNr + j div SizeCube235;
    end;
  end;
end;

var
  T0:Int64;
  cnt,lmt : Uint64;
  i : integer;

Begin
  T0 := GetTickCount64;
  InitSmallPrimes;
  Init235(Sieve235);
  InitDelCube(DelCube);

  sieveNr := 0;
  minIdx := low(tPrimeIdx);
  while Smallprimes[minIdx]<=5 do
    inc(minIdx);
  MaxIdx := minIdx;
  while DelCube[maxIdx].dlSivNum <= sieveNr do
    inc(maxIdx);

  SieveOneSieve;
  i := 1;
  cnt := 0;
  lmt := 100;
  repeat
    if sieve[i] then
    begin
      inc(cnt);
      write(highestDiv(i):4);
      if cnt mod 10 = 0 then
        Writeln;
    end;
    inc(i);
  until cnt = lmt;
  Writeln;

  cnt := 0;
  lmt *=10;
  repeat
    For i in tSv235IDx do
    begin
      if sieve[i] then
      begin
        inc(cnt);
        if cnt = lmt then
        Begin
          OutNum(lmt,i+sieveNr*SizeCube235);
          lmt*= 10;
        end;
      end;
    end;
    inc(sieveNr);
    SieveOneSieve;
  until lmt > 1*1000*1000*1000;

  T0 := GetTickCount64-T0;
  writeln('runtime ',T0/1000:0:3,' s');
end.
