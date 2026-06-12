program CubeFree3;
{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
  {$CODEALIGN proc=16,loop=8} //TIO.RUN loves loop=8
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
const
   //Apéry's Constant
  Z3 : extended  = 1.20205690315959428539973816151144999;
  RezZ3 = 0.831907372580707468683126278821530734417;

type
  tPrimeIdx = 0..192724;// primes til 2,642,246 ^3 ~ 2^64-1= High(Uint64)
  tPrimes = array[tPrimeIdx] of Uint32;
  tDl3 = UInt64;
  tPrmCubed = array[tPrimeIdx] of tDl3;

var
  SmallPrimes: tPrimes;
  {$ALIGN 32}
  PrmCubed : tPrmCubed;

procedure InitSmallPrimes;
//get primes. #0..192724.Sieving only odd numbers
const
  MAXLIMIT = (2642246-1) shr 1;
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

procedure InitPrmCubed(var DC:tPrmCubed);
var
  i,q : Uint64;
begin
  for i in tPrimeIdx do
  begin
    q := SmallPrimes[i];
    q *= sqr(q);
    DC[i] := q;
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
//can test til 2642246^2 ~ 6,98E12
var
  pr : Uint64;
  i : integer;
begin
  result := n;
  for i in tPrimeIdx do
  begin
    pr := Smallprimes[i];
    if pr*pr>result then
      BREAK;
    while (result > pr) AND (result MOD pr = 0) do
      result := result DIV pr;
  end;
end;

procedure OutNum(lmt,n:Uint64);
var
  MaxPrimeFac : Uint64;
begin
  MaxPrimeFac := highestDiv(lmt);
  if  MaxPrimeFac > sqr(SmallPrimes[high(tPrimeIdx)]) then
    MaxPrimeFac := 0;
  writeln(Numb2Usa(lmt):26,'|',Numb2Usa(n):26,'|',Numb2Usa(MaxPrimeFac):15);
end;
//##########################################################################
var
  cnt : Int64;

procedure check(lmt:Uint64;i:integer;flip :Boolean);
var
  p : Uint64;
begin
  For i := i to high(tPrimeIdx) do
  begin
    p := PrmCubed[i];
    if lmt < p then
      BREAK;
    p := lmt DIV p;
    if flip then
      cnt -= p
    else
      cnt += p;
    if p >= PrmCubed[i+1] then
      check(p,i+1,not(flip));
  end;
end;

function GetLmtfromCnt(inCnt:Uint64):Uint64;
begin
  result := trunc(Z3*inCnt);
  repeat
    cnt := result;
    check(result,0,true);
    //new approximation
    inc(result,trunc(Z3*(inCnt-Cnt)));
  until cnt = inCnt;
  //maybe lmt is not cubefree, like 1200 for cnt 1000
  //faster than checking for cubefree of lmt for big lmt
  repeat
    dec(result);
    cnt := result;
    check(result,0,true);
  until cnt < inCnt;
  inc(result);
end;
//##########################################################################

var
  T0,lmt:Int64;
  i : integer;
Begin
  InitSmallPrimes;
  InitPrmCubed(PrmCubed);

  For i := 1 to 100 do
  Begin
    lmt := GetLmtfromCnt(i);
    write(highestDiv(lmt):4);
    if i mod 10 = 0 then
      Writeln;
  end;
  Writeln;

  Writeln('Tested with Apéry´s Constant approximation of ',Z3:17:15);
  write('                   ');
  writeln('Limit  |       cube free numbers  |max prim factor');
  T0 := GetTickCount64;
  lmt := 1;
  For i := 0 to 18 do
  Begin
    OutNum(GetLmtfromCnt(lmt),lmt);
    lmt *= 10;
  end;
  T0 := GetTickCount64-T0;
  writeln(' runtime ',T0/1000:0:3,' s');

end.
