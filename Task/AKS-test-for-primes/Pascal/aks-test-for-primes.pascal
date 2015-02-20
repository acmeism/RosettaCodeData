const
  pasTriMax = 61;
type
  tpasTri =array[0..pasTriMax] of UInt64;

var
  pasTri : tpasTri;

procedure pastriangle(n:longInt);
//calculate the n'th line 0.. middle
var
  j,k: longWord;
begin
  pasTri[0] := 1;
  j := 1;
  while (j<=n) do
  begin
    inc(j);
    k := j SHR 1;
    pasTri[k] :=pasTri[k-1];
    For k := k downto 1 do
      inc(pasTri[k],pasTri[k-1]);
  end;
end;

function CheckPrime(n:longWord):boolean;
var
  i : integer;
  res: boolean;
Begin

  IF n > pasTriMax then
  begin
    writeln(n,' is out of range ');
    EXIT;
  end;

  pastriangle(n);
  res := true;
  i := n shr 1;
  while res AND (i >1) do
  Begin
    res := res AND(pasTri[i] mod n = 0);
    dec(i);
  end;
  CheckPrime := res;
end;

procedure ExpandPoly(n:longWord);
const
  Vz :array[boolean] of char = ('+','-');
var
  j,k: longWord;
  bVz: Boolean;
Begin
  IF n < 2 then
  Begin
    IF n = 0 then
      writeln('(x-1)^0 = 1')
    else
      writeln('(x-1)^1 = x-1');
    EXIT;
  end;

  IF n > pasTriMax then
  begin
    writeln(n,' is out of range ');
    EXIT;
  end;

  pastriangle(n);
  write('(x-1)^',n,' = ');
  k := 0;
  j := n;
  bVz := false;
  repeat
    IF j=n then
      write('x^',j)
    else
      write(Vz[bVz],pasTri[k],'*x^',j);
    bVz := Not(bVz);
    inc(k);
    dec(j);
  until k>= j;
  k := j;
  while k > 0 do
  Begin
    IF j <> 1 then
      write(Vz[bVz],pasTri[k],'*x^',j)
    else
      write(Vz[bVz],pasTri[k],'*x');
    bVz := Not(bVz);
    dec(k);
    dec(j);
  end;
  write(Vz[bVz],pasTri[0]);
  writeln;
end;

var
  n: LongWord;
Begin
  For n := 0 to 9 do
    ExpandPoly(n);
  For n := 2 to pasTriMax do
    IF CheckPrime(n) then
      write(n:3);
end.
