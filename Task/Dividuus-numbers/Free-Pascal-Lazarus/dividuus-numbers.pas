program Dividuus;
{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$CODEALIGN proc=32,loop=8}

//{$DEFINE TestAll} //like https://oeis.org/A118575/b118575.txt
type
  //number in base 10 only used digits 1..9
  tnumdgts = array[0..23] of byte;
  tpnumdgts = pByte;
  tnum9 = record
            nmdgts : tnumdgts;
            nmNum  : UInt64;
            nmNum9  : UInt64;
            nmSumDgt : UInt64;
            nmMulDgt : UInt64;
            nmDgtRoot  :Uint32;
            nmDgtMulRoot  :Uint32;
            nmMaxDgtIdx :byte;
          end;

var
  Mul3Dgt : array[0..999] of UInt32;
  DgtRootTbl : array[0..21*9] of Uint32;

procedure InitMulDgt;
var
  i,j,k,l : Int32;
begin
  l := 999;
  For i := 9 downto 0 do
    For j := 9 downto 0 do
      For k := 9 downto 0 do
      Begin
        Mul3Dgt[l] := i*j*k;
        dec(l);
      end;
end;

procedure InitDgtRootTable;
var
  i : Uint32;
begin
  DgtRootTbl[0] := 0;
  for i := 1 to 21*9 do
    DgtRootTbl[i]:= (i-1) MOD 9 +1;
end;

procedure OutNum(const n:tnum9;i :Uint32);
begin
  with n do
    writeln(i:6,nmNum:12,nmMulDgt:10,nmSumDgt:4,nmDgtRoot:4,nmDgtMulRoot:4,nmNum9:12);
end;

procedure InitNum(var num:tnum9;n:Uint64);
//convert number to tNum9
var
  s : string[31];
  digitsMul,newN,newN9 : Uint64;
  digitsSum,
  idx,l,dgt : integer;
begin
  str(n,s);
  newN := 0;
  newN9 := 0;
  digitsSum := 0;
  digitsMul := 1;
  with num do
  begin
    l := length(s);
    For idx := 1 to l do
    begin
      dgt := Ord(s[idx])-Ord('0');
      if dgt = 0 then
        dgt := 1;
      nmdgts[l-idx] := dgt;
      newN  := newN*10+dgt;
      newN9 := newN9*9+dgt;
      digitsSum += dgt;
      digitsMul *= dgt;
    end;
    nmSumDgt := digitsSum;
    nmMulDgt := digitsMul;
    nmNum := newN;
    nmNum9 := newN9;
    nmdgtRoot := 128;
    nmdgtMulroot := 128;
    nmMaxDgtIdx := l-1;
  end;
end;

function GetMulDigits(n:Uint64):UInt64;inline;
var
  q :Uint64;
  pMul3Dgt : pUInt32;
begin
  pMul3Dgt := @Mul3Dgt[0];
  result := 1;
  while n >= 1000 do
  begin
    q := n div 1000;
    result *= pMul3Dgt[n-1000*q];
    n := q;
  end;
  If n>=100 then
    result *= pMul3Dgt[n]
  else
    if n>=10 then
       result *= pMul3Dgt[n+100]
    else
      result *= n;//Mul3Dgt[n+110]
end;

function GetMulRoot(n : UInt64):Uint64;
Begin
  result := n;
  while result >=10 do
    result := GetMulDigits(result);
end;

function CheckDividuus(var num:tnum9):Boolean;inline;
var
  n : Uint64;
  dgtRoot : Uint32;
begin
  result := false;
  with num do
  begin
    n := nmNum;
    if n mod nmSumDgt <> 0 then
      EXIT;

    if n mod nmMulDgt <> 0 then
      EXIT;

    dgtRoot := DgtRootTbl[nmSumDgt];
    nmDgtRoot := dgtRoot;
    if dgtRoot = 0 then
      EXIT
    else
      if n mod dgtRoot <> 0 then
        EXIT;

    dgtRoot := GetMulRoot(nmMulDgt);
    nmDgtMulRoot :=  dgtRoot;
    if dgtRoot = 0 then
      EXIT
    else
      if n mod dgtRoot <> 0 then
        EXIT;
  end;
  result := true;
end;

procedure IncNum9(var tn:tNum9);
var
  fac : UInt64;
  idx,dgt : UInt32;
begin
  idx := 0;
  with tn do
  Begin
    fac := 1;
    inc(nmNum9,fac);
    inc(nmNum,fac);
    repeat
      dgt := nmdgts[idx];
      nmMulDgt := nmMulDgt DIV dgt;
      dec(nmSumDgt,dgt);
      inc(dgt);
      if dgt < 10 then
      begin
        nmdgts[idx]:= dgt;
        nmMulDgt := nmMulDgt * dgt;
        inc(nmSumDgt,dgt);
        break;
      end;
      dgt:= 1;
      inc(nmNum,fac);
      fac := fac*10;
      nmdgts[idx] :=dgt;
      inc(nmSumDgt,dgt);
      inc(idx);
    until idx > nmMaxDgtIdx;

    If idx > High(nmdgts) then
      EXIT;
    if nmMaxDgtIdx<Idx then
    begin
      nmMaxDgtIdx := Idx;
      nmdgts[idx] := 1;
      inc(nmSumDgt);
    end;
    nmdgtRoot := 128;
    nmdgtMulroot := 128;
  end;
end;

var
  num : tnum9;
  i : integer;
Begin
  InitDgtRootTable;
  InitMulDgt;
  with num do
  begin
    nmdgts[0] := 1;
    nmNum     := 1;
    nmNum9    := 1;
    nmSumDgt  := 1;
    nmMulDgt  := 1;
    nmDgtRoot := 1;
    nmDgtMulRoot := 1;
    nmMaxDgtIdx := 0;
  end;

  writeln('First fifty Dividuus numbers:');
  i := 0;
  repeat
    if CheckDividuus(num) then
    Begin
      inc(i);
      write(num.nmNum:6);
      if i mod 10 = 0 then
        writeln;
    end;
    IncNum9(num);
  until i >= 50;
{$IFDEF TestAll}
  repeat
    if CheckDividuus(num) then
      inc(i);
    IncNum9(num);
  until num.nmNum>=990*1000*1000-1;
{$ELSE}
  InitNum(num,990*1000*1000);
{$ENDIF}
  writeln;
  writeln(' index   number   digits Mul Sum rtS rtM   base9 Idx');
  repeat
    if CheckDividuus(num) then
    Begin
      inc(i);
      OutNum(num,i);
    end;
    IncNum9(num);
  until num.nmNum>=1000*1000*1000-1;
  writeln('Test transit');
  i := 0;
  OutNum(num,i);
  IncNum9(num);
  OutNum(num,i);
  writeln;
end.
