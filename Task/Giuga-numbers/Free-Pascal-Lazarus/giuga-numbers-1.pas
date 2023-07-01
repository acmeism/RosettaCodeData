program Giuga;

{$IFDEF FPC}
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL}  {$COPERATORS ON}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils
{$IFDEF WINDOWS},Windows{$ENDIF}
  ;
//######################################################################
//prime decomposition only squarefree and multiple of 6

type
  tprimeFac = packed record
                 pfpotPrimIdx : array[0..9] of Uint64;
                 pfMaxIdx  : Uint32;
               end;
  tpPrimeFac = ^tprimeFac;
  tPrimes = array[0..65535] of Uint32;

var
  {$ALIGN 8}
  SmallPrimes: tPrimes;
  {$ALIGN 32}

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

function OutPots(pD:tpPrimeFac;n:NativeInt):Ansistring;
var
  s: String[31];
  chk,p: NativeInt;
Begin
  str(n,s);
  result := s+' :';
  with pd^ do
  begin
    chk := 1;
    For n := 0 to pfMaxIdx-1 do
    Begin
      if n>0 then
        result += '*';
      p := pfpotPrimIdx[n];
      chk *= p;
      str(p,s);
      result += s;
    end;
    str(chk,s);
    result += '_chk_'+s+'<';
  end;
end;

function IsSquarefreeDecomp6(var res:tPrimeFac;n:Uint64):boolean;inline;
//factorize only not prime/semiprime and squarefree n= n div 6
var
  pr,i,q,idx :NativeUInt;
Begin
  with res do
  Begin
    Idx := 2;

    q := n DIV 5;
    if n = 5*q then
    Begin
      pfpotPrimIdx[2] := 5;
      n := q;
      q := q div 5;
      if q*5=n then
        EXIT(false);
      inc(Idx);
    end;

    q := n DIV 7;
    if n = 7*q then
    Begin
      pfpotPrimIdx[Idx] := 7;
      n := q;
      q := q div 7;
      if q*7=n then
        EXIT(false);
      inc(Idx);
    end;

    q := n DIV 11;
    if n = 11*q then
    Begin
      pfpotPrimIdx[Idx] := 11;
      n := q;
      q := q div 11;
      if q*11=n then
        EXIT(false);
      inc(Idx);
    end;

    if Idx < 3 then
      Exit(false);

    i := 5;
    while i < High(SmallPrimes) do
    begin
      pr := SmallPrimes[i];
      q := n DIV pr;
      //if n < pr*pr
      if pr > q then
        BREAK;
      if n = pr*q then
      Begin
        pfpotPrimIdx[Idx] := pr;
        n := q;
        q := n div pr;
        if pr*q = n then
          EXIT(false);
        inc(Idx);
      end;
      inc(i);
     end;
     if n <> 1 then
     begin
       pfpotPrimIdx[Idx] := n;
       inc(Idx);
     end;
     pfMaxIdx := idx;
  end;
  exit(true);
end;

function ChkGiuga(n:Uint64;pPrimeDecomp :tpPrimeFac):boolean;inline;
var
  p : Uint64;
  idx: NativeInt;
begin
  with pPrimeDecomp^ do
  Begin
    idx := pfMaxIdx-1;
    repeat
      p := pfpotPrimIdx[idx];
      result := (((n DIV p)-1)MOD p) = 0;
      if not(result) then
        EXIT;
      dec(idx);
    until idx<0;
  end;
end;

const
  LMT = 24423128562;//2214408306;//
var
  PrimeDecomp :tPrimeFac;
  T0:Int64;
  n,n6 : UInt64;
  cnt:Uint32;
Begin
  InitSmallPrimes;

  T0 := GetTickCount64;
  with PrimeDecomp do
  begin
    pfpotPrimIdx[0]:= 2;
    pfpotPrimIdx[1]:= 3;
  end;
  n := 0;
  n6 := 0;
  cnt := 0;
  repeat
    //only multibles of 6
    inc(n,6);
    inc(n6);
    //no square factor of 2
    if n AND 3 = 0 then
      continue;
    //no square factor of 3
    if n MOD 9 = 0 then
      continue;

    if IsSquarefreeDecomp6(PrimeDecomp,n6)then
      if ChkGiuga(n,@PrimeDecomp) then
      begin
        inc(cnt);
        writeln(cnt:3,'..',OutPots(@PrimeDecomp,n),'  ',(GettickCount64-T0)/1000:6:3,' s');
      end;
  until n >= LMT;
  T0 := GetTickCount64-T0;
  writeln('Found ',cnt);
  writeln('Tested til ',n,' runtime ',T0/1000:0:3,' s');
  writeln;
  writeln(OutPots(@PrimeDecomp,n));
end.
