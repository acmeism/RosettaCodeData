program BlumInteger;
{$IFDEF FPC}  {$MODE DELPHI}{$Optimization ON,ALL} {$ENDIF}
{$IFDEF WINDOWS}{$APPTYPE CONSOLE}{$ENDIF}
{
// for commatize = Numb2USA(IntToStr(n))
uses
  sysutils, //IntToStr
  strutils; //Numb2USA
}
const
  LIMIT = 10*1000*1000;// >750
type
  tP4n3 = array of Uint32;

function CommaUint(n : Uint64):AnsiString;
//commatize only positive Integers
var
  fromIdx,toIdx :Int32;
  pRes : pChar;
Begin
  str(n,result);
  fromIdx := length(result);
  toIdx := fromIdx-1;
  if toIdx < 3 then
    exit;

  toIdx := 4*(toIdx DIV 3)+toIdx MOD 3 +1 ;
  setlength(result,toIdx);
  pRes := @result[1];
  dec(pRes);
  repeat
    pRes[toIdx]   := pRes[FromIdx];
    pRes[toIdx-1] := pRes[FromIdx-1];
    pRes[toIdx-2] := pRes[FromIdx-2];
    pRes[toIdx-3] := ',';
    dec(toIdx,4);
    dec(FromIdx,3);
  until FromIdx<=3;
  while fromIdx>=1 do
  Begin
    pRes[toIdx] := pRes[FromIdx];
    dec(toIdx);
    dec(fromIdx);
  end;
end;

procedure Sieve4n_3_Primes(Limit:Uint32;var P4n3:tP4n3);
var
  sieve : array of byte;
  BlPrCnt,idx,n,j: Uint32;
begin
  //DIV 3 -> smallest factor of Blum Integer
  n := (LIMIT DIV 3 -3) DIV 4+ 1;
  setlength(sieve,n);
  setlength(P4n3,n);

  BlPrCnt:= 0;
  idx := 0;
  repeat
    if sieve[idx]= 0 then
    begin
      n := idx*4+3;
      P4n3[BlPrCnt] := n;
      inc(BlPrCnt);
      j := idx+n;
      if j > High(sieve) then
        break;
      while j <= High(sieve) do
      begin
        sieve[j] := 1;
        inc(j,n);
      end;
    end;
    inc(idx);
  until idx>High(sieve);
  //collect the rest
  for idx := idx+1 to High(sieve) do
    if sieve[idx]=0 then
    Begin
      P4n3[BlPrCnt] := idx*4+3;
      inc(BlPrCnt);
    end;
  setlength(P4n3,BlPrCnt);
  setlength(sieve,0);
end;

var
  BlumField : array[0..LIMIT] of boolean;
  BlumPrimes : tP4n3;
  EndDigit : array[0..9] of Uint32;
  k : Uint64;
  n,idx,j,P4n3Cnt : Uint32;
begin
  Sieve4n_3_Primes(Limit,BlumPrimes);
  P4n3Cnt := length(BlumPrimes);
  writeln('There are ',CommaUint(P4n3Cnt),' needed primes 4*n+3 to Limit ',CommaUint(LIMIT));
  dec(P4n3Cnt);
  writeln;

  //generate Blum-Integers
  For idx := 0 to P4n3Cnt do
  Begin
    n := BlumPrimes[idx];
    For j := idx+1 to P4n3Cnt do
    Begin
      k := n*BlumPrimes[j];
      if k>LIMIT then
        BREAK;
      BlumField[k] := true;
    end;
  end;

  writeln('First 50 Blum-Integers ');
  idx :=0;
  j := 0 ;
  repeat
    while (idx<LIMIT) AND Not(BlumField[idx]) do
      inc(idx);
    if idx = LIMIT then
      BREAK;
    if j mod 10 = 0 then
      writeln;
    write(idx:5);
    inc(j);
    inc(idx);
  until j >= 50;
  Writeln(#13,#10);

  //count and calc and summate decimal digit
  writeln('                               relative occurence of digit');
  writeln('     n.th  |Blum-Integer|Digit: 1          3          7          9');
  idx :=0;
  j := 0 ;
  n := 0;
  k := 26828;
  repeat
    while (idx<LIMIT) AND Not(BlumField[idx]) do
      inc(idx);
    if idx = LIMIT then
      BREAK;
    //count last decimal digit
    inc(EndDigit[idx MOD 10]);
    inc(j);
    if j = k then
    begin
      write(CommaUint(j):10,' | ',CommaUint(idx):11,'| ');
      write(EndDigit[1]/j*100:7:3,'%  |');
      write(EndDigit[3]/j*100:7:3,'%  |');
      write(EndDigit[7]/j*100:7:3,'%  |');
      writeln(EndDigit[9]/j*100:7:3,'%');
      if k < 100000 then
        k := 100000
      else
        k += 100000;
    end;
    inc(idx);
  until j >= 400000;
  Writeln;
end.
