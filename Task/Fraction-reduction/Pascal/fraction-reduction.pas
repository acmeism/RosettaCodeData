program FracRedu;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,ALL}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  SysUtils;

type
  tdigit = 0..9;
const
  cMaskDgt: array [tdigit] of Uint32 = (1, 2, 4, 8, 16, 32, 64, 128, 256, 512
    {,1024,2048,4096,8193,16384,32768});
  cMaxDigits = High(tdigit);
type
  tPermfield = array[tdigit] of uint32;
  tpPermfield = ^tPermfield;

  tDigitCnt = array[tdigit] of Uint32;

  tErg = record
           numUsedDigits : Uint32;
           numUnusedDigit : array[tdigit] of Uint32;
           numNormal : Uint64;// so sqr of number stays in Uint64
           dummy : array[0..7] of byte;//-> sizeof(tErg) = 64
         end;
  tpErg = ^tErg;
var
  Erg: array of tErg;
  pf_x, pf_y: tPermfield;
  DigitCnt :tDigitCnt;
  permcnt, UsedDigits,Anzahl: NativeUint;

  function Fakultaet(i: integer): integer;
  begin
    Result := 1;
    while i > 1 do
    begin
      Result := Result * i;
      Dec(i);
    end;
  end;

  procedure OutErg(dgt: Uint32;pi,pJ:tpErg);
  begin
    writeln(dgt:3,'  ', pi^.numUnusedDigit[dgt],'/',pj^.numUnusedDigit[dgt]
            ,' = ',pi^.numNormal,'/',pj^.numNormal);
  end;

  function Check(pI,pJ : tpErg;Nud :Word):integer;
  var
    dgt: NativeInt;
  Begin
    result := 0;
    dgt := 1;
    NUD := NUD SHR 1;
    repeat
      IF NUD AND 1 <> 0 then
      Begin
        If  pI^.numNormal*pJ^.numUnusedDigit[dgt] = pJ^.numNormal*pI^.numUnusedDigit[dgt] then
        Begin
          inc(result);
          inc(DigitCnt[dgt]);
          IF Anzahl < 110 then
            OutErg(dgt,pI,pJ);
        end;
      end;
      inc(dgt);
      NUD := NUD SHR 1;
    until NUD = 0;
  end;

  procedure CheckWithOne(pI : tpErg;j,Nud:Uint32);
  var
    pJ : tpErg;
    l : NativeUInt;
  Begin
    pJ := pI;
    if UsedDigits <5 then
    Begin
      for j := j+1 to permcnt do
      begin
        inc(pJ);
        //digits used by both numbers
        l := NUD AND pJ^.numUsedDigits;
        IF l <> 0 then
          inc(Anzahl,Check(pI,pJ,l));
      end;
    end
    else
    Begin
      for j := j+1 to permcnt do
      begin
        inc(pJ);
        l := NUD AND pJ^.numUsedDigits;
        inc(Anzahl,Check(pI,pJ,l));
      end;
    end;
  end;

  procedure SearchMultiple;
  var
    pI : tpErg;
    i : NativeUInt;
  begin
    pI := @Erg[0];
    for i := 0 to permcnt do
    Begin
      CheckWithOne(pI,i,pI^.numUsedDigits);
      inc(pI);
    end;
  end;

  function BinomCoeff(n, k: byte): longint;
  var
    i: longint;
  begin
    {n ueber k  = n ueber (n-k) , also kuerzere Version waehlen}
    if k > n div 2 then
      k := n - k;
    Result := 1;
    if k <= n then
      for i := 1 to k do
        Result := Result * (n - i + 1) div i;{geht immer  ohne Rest }
  end;

  procedure InsertToErg(var E: tErg; const x: tPermfield);
  var
    n : Uint64;
    k,i,j,dgt,nud: NativeInt;
  begin
    // k of PermKoutofN is reduced by one for 9 digits
    k := UsedDigits;
    n := 0;
    nud := 0;
    for i := 1 to k do
    begin
      dgt := x[i];
      nud := nud or cMaskDgt[dgt];
      n := n * 10 + dgt;
    end;
    with E do
    begin
      numUsedDigits := nud;
      numNormal := n;
    end;
    //calc all numbers with one removed digit
    For J := k downto 1 do
    Begin
      n := 0;
      for i := 1 to j-1 do
        n := n * 10 + x[i];
      for i := j+1 to k do
        n := n * 10 + x[i];
      E.numUnusedDigit[x[j]] := n;
    end;
  end;

  procedure PermKoutofN(k, n: nativeInt);
  var
    x, y: tpPermfield;
    i, yi, tmp: NativeInt;
  begin
    //initialise
    x := @pf_x;
    y := @pf_y;
    permcnt := 0;
    if k > n then
      k := n;
    if k = n then
      k := k - 1;
    for i := 1 to n do
      x^[i] := i;
    for i := 1 to k do
      y^[i] := i;

    InserttoErg(Erg[permcnt], x^);
    i := k;
    repeat
      yi := y^[i];
      if yi < n then
      begin
        Inc(permcnt);
        Inc(yi);
        y^[i] := yi;
        tmp := x^[i];
        x^[i] := x^[yi];
        x^[yi] := tmp;
        i := k;
        InserttoErg(Erg[permcnt], x^);
      end
      else
      begin
        repeat
          tmp := x^[i];
          x^[i] := x^[yi];
          x^[yi] := tmp;
          Dec(yi);
        until yi <= i;
        y^[i] := yi;
        Dec(i);
      end;
    until (i = 0);
  end;

  procedure OutDigitCount;
   var
     i : tDigit;
  Begin
    writeln('omitted digits 1 to 9');
    For i := 1 to 9do
      write(DigitCnt[i]:UsedDigits);
    writeln;
  end;

  procedure ClearDigitCount;
   var
     i : tDigit;
  Begin
    For i := low(DigitCnt) to high(DigitCnt) do
      DigitCnt[i] := 0;
  end;

var
  t1, t0: TDateTime;
begin
  For UsedDigits := 8 to 9 do
  Begin
    writeln('Used digits ',UsedDigits);
    T0 := now;
    ClearDigitCount;
    setlength(Erg, Fakultaet(UsedDigits) * BinomCoeff(cMaxDigits, UsedDigits));
    Anzahl := 0;
    permcnt := 0;
    PermKoutOfN(UsedDigits, cMaxDigits);
    SearchMultiple;
    T1 := now;
    writeln('Found solutions ',Anzahl);
    OutDigitCount;
    writeln('time taken ',FormatDateTime('HH:NN:SS.zzz', T1 - T0));
    setlength(Erg, 0);
    writeln;
  end;
end.
