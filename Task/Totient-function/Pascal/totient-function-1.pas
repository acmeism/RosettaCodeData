{$IFDEF FPC}
  {$MODE DELPHI}
{$IFEND}
function gcd_mod(u, v: NativeUint): NativeUint;inline;
//prerequisites  u > v and u,v > 0
  var
    t: NativeUInt;
  begin
    repeat
      t := u;
      u := v;
      v := t mod v;
    until v = 0;
    gcd_mod := u;
  end;

function Totient(n:NativeUint):NativeUint;
var
  i : NativeUint;
Begin
  result := 1;
  For i := 2 to n do
    inc(result,ORD(GCD_mod(n,i)=1));
end;

function CheckPrimeTotient(n:NativeUint):Boolean;inline;
begin
  result :=  (Totient(n) = (n-1));
end;

procedure OutCountPrimes(n:NativeUInt);
var
  i,cnt :  NativeUint;
begin
  cnt := 0;
  For i := 1 to n do
    inc(cnt,Ord(CheckPrimeTotient(i)));
  writeln(n:10,cnt:8);
end;

procedure display(n:NativeUint);
var
  idx,phi : NativeUint;
Begin
  if n = 0 then
    EXIT;
  writeln('number n':5,'Totient(n)':11,'isprime':8);
  For idx := 1 to n do
  Begin
    phi := Totient(idx);
    writeln(idx:4,phi:10,(phi=(idx-1)):12);
  end
end;
var
  i : NativeUint;
Begin
  display(25);

  writeln('Limit  primecount');
  i := 100;
  repeat
    OutCountPrimes(i);
    i := i*10;
  until i >100000;
end.
