program DivByDgtsNotByProdOfDgts;

function ProdDigits(n:cardinal):cardinal;
// returns product of Digits if n is divisible by digits
var
  p,q,r,dgt : cardinal;
begin
  q := n;
  p := 1;
  repeat
    r := q DIV 10;
    dgt := q-10*r;
    if (dgt= 0)OR(n mod dgt <> 0) then
      EXIT(0);
    p := p*dgt;
    q := r;
  until q = 0;
  Exit(p)
end;

const
  LimitLow  =    1;
  LimitHigh = 1000;
var
  i,mul,cnt : Cardinal;
BEGIN
  cnt := 0;
  writeln('Limits ',LimitLow,'..',LimitHigh);
  For i := LimitLow to LimitHigh do
  begin
    mul := ProdDigits(i);
    if (mul <> 0)  AND (i MOD MUL<>0) then
    Begin
      write(i:4);
      inc(cnt);
      if cnt AND 15= 0 then
        writeln;
    end;
  end;
  if cnt AND 15 <> 0 then
    writeln;
  writeln(' count : ',cnt);
END.
