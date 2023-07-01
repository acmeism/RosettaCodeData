const
  pasTriMax = 61;

type
  TPasTri = array[0 .. pasTriMax] of UInt64;

var
  pasTri: TPasTri;

procedure PascalTriangle(n: LongWord);
// Calculate the n'th line 0.. middle
var
  j, k: LongWord;
begin
  pasTri[0] := 1;
  j := 1;
  while j <= n do
  begin
    Inc(j);
    k := j div 2;
    pasTri[k] := pasTri[k - 1];
    for k := k downto 1 do
      Inc(pasTri[k], pasTri[k - 1]);
  end;
end;

function IsPrime(n: LongWord): Boolean;
var
  i: Integer;
begin
  if n > pasTriMax then
  begin
    WriteLn(n, ' is out of range');
    Halt;
  end;

  PascalTriangle(n);
  Result := true;
  i := n div 2;
  while Result and (i > 1) do
  begin
    Result := Result and (pasTri[i] mod n = 0);
    Dec(i);
  end;
end;

procedure ExpandPoly(n: LongWord);
const
  Vz: array[Boolean] of Char = ('+', '-');
var
  j: LongWord;
  bVz: Boolean;
begin
  if n > pasTriMax then
  begin
    WriteLn(n,' is out of range');
    Halt;
  end;

  case n of
    0: WriteLn('(x-1)^0 = 1');
    1: WriteLn('(x-1)^1 = x-1');
  else
    PascalTriangle(n);
    Write('(x-1)^', n, ' = ');
    Write('x^', n);
    bVz := true;
    for j := n - 1 downto n div 2 + 1 do
    begin
      Write(vz[bVz], pasTri[n - j], '*x^', j);
      bVz := not bVz;
    end;
    for j := n div 2 downto 2 do
    begin
      Write(vz[bVz], pasTri[j], '*x^', j);
      bVz := not bVz;
    end;
    Write(vz[bVz], pasTri[1], '*x');
    bVz := not bVz;
    WriteLn(vz[bVz], pasTri[0]);
  end;
end;

var
  n: LongWord;
begin
  for n := 0 to 9 do
    ExpandPoly(n);
  for n := 2 to pasTriMax do
    if IsPrime(n) then
      Write(n:3);
  WriteLn;
end.
