program m_by_n_sumofdgts_m;
//Like https://oeis.org/A131382/b131382.txt
{$IFDEF FPC} {$MODE DELPHI} {$OPTIMIZATION ON,ALL} {$ENDIF}
uses
  sysutils;
const
   BASE = 10;
   BASE4 = BASE*BASE*BASE*BASE;
   MAXDGTSUM4 = 4*(BASE-1);
var
  {$ALIGN 32}
  SoD: array[0..BASE4-1] of byte;
  {$ALIGN 32}
  DtgBase4 :array[0..7] of Uint32;
  DtgPartSums :array[0..7] of Uint32;
  DgtSumBefore :array[0..7] of Uint32;


procedure Init_SoD;
var
  d0,d1,i,j : NativeInt;
begin
  i := 0;
  For d1 := 0 to BASE-1 do
    For d0 := 0 to BASE-1 do
      begin SoD[i]:= d1+d0;inc(i); end;

  j := Base*Base;
  For i := 1 to Base*Base-1 do
    For d1 := 0 to BASE-1 do
      For d0 := 0 to BASE-1 do
      begin
        SoD[j] := SoD[i]+d1+d0;
        inc(j);
      end;
end;

procedure OutDgt;
var
   i : integer;
begin
  for i := 5 downto 0 do
    write(DtgBase4[i]:4);
  writeln;
  for i := 5 downto 0 do
    write(DtgPartSums[i]:4);
  writeln;
  for i := 5 downto 0 do
    write(DgtSumBefore[i]:4);
  writeln;
end;

procedure InitDigitSums(m:NativeUint);
var
  n,i,s: NativeUint;
begin
  //constructing minimal number with sum of digits = m ;k+9+9+9+9+9+9
  //21 -> 299
  n := m;
  if n>BASE then
  begin
    i := 1;
    while n>BASE-1 do
    begin
      i *= BASE;
      dec(n,BASE-1);
    end;
    n := i*(n+1)-1;
    //make n multiple of m
    n := (n div m)*m;
    //m ending in 0
    i := m;
    while i mod BASE = 0 do
    begin
      n *= BASE;
      i := i div BASE;
    end;
  end;

  For i := 0 to 4 do
  begin
    s := n MOD BASE4;
    DtgBase4[i] := s;
    DtgPartSums[i] := SoD[s];
    n := (n-s) DIV BASE4;
  end;

  s := 0;
  For i := 3 downto 0 do
  begin
    s += DtgPartSums[i+1];
    DgtSumBefore[i]:= s;
  end;
end;


function CorrectSums(sum:NativeUint):NativeUint;
var
i,q,carry : NativeInt;
begin
  i := 0;
  q := sum MOD Base4;
  sum := sum DIV Base4;
  result := q;

  DtgBase4[i] := q;
  DtgPartSums[i] := SoD[q];

  carry := 0;
  repeat
    inc(i);
    q := sum MOD Base4+DtgBase4[i]+carry;
    sum := sum DIV Base4;
    carry := 0;
    if q >= BASE4 then
    begin
      carry := 1;
      q -= BASE4;
    end;
    DtgBase4[i]:= q;
    DtgPartSums[i] := SoD[q];
  until (sum =0) AND( carry = 0);

  sum := 0;
  For i := 3 downto 0 do
  begin
    sum += DtgPartSums[i+1];
    DgtSumBefore[i]:= sum;
  end;
end;

function TakeJump(dgtSum,m:NativeUint):NativeUint;
var
  n,i,j,carry : nativeInt;
begin
  i := dgtsum div MAXDGTSUM4-1;
  n := 0;
  j := 1;
  for i := i downto 0 do
  Begin
    n:= n*BASE4+DtgBase4[i];
    j:= j*BASE4;
  end;
  n := ((j-n) DIV m)*m;
//  writeln(n:10,DtgBase4[i]:10);
  i := 0;
  carry := 0;
  repeat
    j := DtgBase4[i]+ n mod BASE4 +carry;
    n := n div BASE4;
    carry := 0;
    IF j >=BASE4 then
    begin
      j -= BASE4;
      carry := 1;
    end;
    DtgBase4[i] := j;
    DtgPartSums[i]:= SoD[j];
    inc(i);
  until (n= 0) AND (carry=0);
  j := 0;
  For i := 3 downto 0 do
  begin
    j += DtgPartSums[i+1];
    DgtSumBefore[i]:= j;
  end;
  result := DtgBase4[0];
end;

procedure CalcN(m:NativeUint);
var
  dgtsum,sum: NativeInt;
begin
  InitDigitSums(m);

  sum := DtgBase4[0];
  dgtSum:= m-DgtSumBefore[0];
  //  while dgtsum+SoD[sum] <> m do
  while dgtsum<>SoD[sum] do
  begin
    inc(sum,m);
    if sum >= BASE4 then
    begin
      sum := CorrectSums(sum);
      dgtSum:= m-DgtSumBefore[0];
      if dgtSum > MAXDGTSUM4 then
      begin
        sum := TakeJump(dgtSum,m);
        dgtSum:= m-DgtSumBefore[0];
      end;
    end;
  end;
  DtgBase4[0] := sum;
end;

var
  T0:INt64;
  i : NativeInt;
  m,n: NativeUint;
Begin
  T0 := GetTickCount64;
  Init_SoD;
  for m := 1 to 70 do
  begin
    CalcN(m);
    //Check sum of digits
    n := SoD[DtgBase4[4]];
    For i := 3 downto 0 do
      n += SoD[DtgBase4[i]];
    If n<>m then
    begin
      writeln('ERROR at ',m);
      HALT(-1);
    end;

    n := DtgBase4[4];
    For i := 3 downto 0 do
      n := n*BASE4+DtgBase4[i];
    write(n DIV m :15);
    if m mod 10 = 0 then
      writeln;
  end;
  writeln;
  writeln('Total runtime  ',GetTickCount64-T0,' ms');
  {$IFDEF WINDOWS} readln{$ENDIF}
end.
