program SumTwinPrimeSquare;
{$IFDEF FPC}
  {$MODE Delphi}
  {$Optimization ON,All}
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  SysUtils;
const
  MaxRoot = 10*1000*1000;

type
  tPrimeDelta = array of Uint8;
  procedure SievePrimes(var prD:tPrimeDelta;size: int32);
    var
    pPD : pUint8;
    p,j, SqrtBound: Uint32;
  begin
    setlength(prD, 0);
    setlength(prD, size + 1);
    pPD := @prD[0];
    SqrtBound := Trunc(Sqrt(size));
    for p := 2 to SqrtBound do
      if pPD[p] = 0 then
      begin
        J := p * p;
        repeat
          pPD[J] := 1;
          J += p;
        until J > size;
      end;
    pPD[0]:= 1;
    pPD[1]:= 1;
  end;

  function GetPrimeDelta(var prD:tPrimeDelta;size: Uint32):Int32;
  var
    pPD : pUint8;
    LastP,p : Uint32;
  Begin
    SievePrimes(prD,size);
    pPD := @prD[0];
    result := 0;
    LastP := 0;
    p := 0;
    repeat
      if pPD[p] = 0 then
      begin
        pPD[result] := p-LastP;
        LastP := p;
        inc(result);
      end;
      inc(p);
    until p> Size;
    Setlength(prD,result);
    result -=1;
   end;

   procedure OutRes(i,q:Uint32);
   var
     sq :Uint64;
   begin
     write(i: 7, q: 8, '^2');
     sq := (q*q) shr 1;
     writeln(sq - 1: 16, '+', sq + 1);
   end;

  function IsTwinPrime(pPD : pUint8;N: nativeuint): boolean;
    //check if n and n+2 are prime
  var
    p,idx, md: Uint32;
  begin
    if n <32 then  Exit(N in [3,5,11,17,29]);
    p := 2;
    idx := 1;
    repeat
      p += pPD[idx];
      inc(idx);
      md := n mod p;
      // if p divisor of n or (n+2)
      if (md = 0) or (md + 2 = p) then
        EXIT(False);
    until (sqr(p) > n);
    Result := True;
  end;

var
  primeDelta :TprimeDelta;
  LowHalfSqr: Uint64;
  pPD : pUint8;
  T : int64;
  i, q,lstQ : nativeuint;
begin
  T := GetTickCount64;
  GetPrimeDelta(primeDelta,MaxRoot+2310);
  pPD := @primeDelta[0];
  i := 0;
  //must be even, so square is even. Even more, it's divisible by 4
  q := 0;
  LowHalfSqr := Uint64(-1);
  repeat
    Inc(q, 2);
    LowHalfSqr :=sqr(q) shr 1-1;
    if IsTwinPrime(pPD,LowHalfSqr) then
    begin
      Inc(i);
      lstQ := q;
      if (i <=69) then OutRes(i,q);
      if (i = 4288) then  OutRes(i,q);
    end;
  until q >= MaxRoot;
  OutRes(i,lstQ);
  T := GetTickCount64 - T;
  Writeln(' Done in ', T, ' ms');
  {$IFDEF WINDOWS}
    readln;
  {$ENDIF}
end.
