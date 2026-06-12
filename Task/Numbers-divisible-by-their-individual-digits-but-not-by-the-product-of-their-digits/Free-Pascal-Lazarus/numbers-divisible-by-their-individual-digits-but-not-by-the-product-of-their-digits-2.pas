program DivByDgtsNotByProdOfDgts;
{$MODE DELPHI}
const
  LimitLow  = 1;// must start within 1..9
  LimitHigh = 100*1000*1000;//4000*1000*1000;
var
  d :array[0..16] of NativeUInt;

function JmpOvZero(i: Cardinal):NativeUInt;
var
 idx,delta :NativeUInt;
begin
  result := i;
  idx := 0;
  delta := 1;
  repeat
    inc(result,delta);
    d[idx]:= 9;
    delta *= 10;
    inc(idx);
    dec(d[idx]);
  until d[idx] <> 0;
end;

function ProdDigits(n:NativeUInt):NativeUInt;inline;
// returns product of Digits if n is divisible by digits
var
  q,r,dgt : Uint32;
begin
  q := n;
  result := 1;
  repeat
    r := q DIV 10;
    dgt := q-10*r;
    if (n mod dgt <> 0) then
      EXIT(0);
    result *= dgt;
    q := r;
  until r = 0;
end;

var
  i,mul,cnt : Cardinal;
BEGIN
  cnt := 0;
  For i := Low(d) to High(d) do
    d[i] := 10;
  d[0]:= 10-LimitLow;
  writeln('Limits ',LimitLow,'..',LimitHigh);
  i := limitLow;
  repeat
    dec(d[0]);
    mul := ProdDigits(i);
    if (mul <> 0) AND (i MOD MUL<>0) then
      inc(cnt);
    if (d[0]) = 0 then
      i := JmpOvZero(i);
    inc(i);
  until i > LimitHigh;
  writeln('count : ',cnt);
END.
