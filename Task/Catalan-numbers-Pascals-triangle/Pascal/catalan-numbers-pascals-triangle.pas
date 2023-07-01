Program CatalanNumbers
type
  tElement = Uint64;
var
  Catalan : array[0..50] of tElement;
procedure GetCatalan(L:longint);
var
  PasTri : array[0..100] of tElement;
  j,k: longInt;
begin
  l := l*2;
  PasTri[0] := 1;
  j    := 0;
  while (j<L) do
  begin
    inc(j);
    k := (j+1) div 2;
    PasTri[k] :=PasTri[k-1];
    For k := k downto 1 do
      inc(PasTri[k],PasTri[k-1]);
    IF NOT(Odd(j)) then
    begin
      k := j div 2;
      Catalan[k] :=PasTri[k]-PasTri[k-1];
    end;
  end;
end;

var
  i,l: longint;
Begin
  l := 15;
  GetCatalan(L);
  For i := 1 to L do
    Writeln(i:3,Catalan[i]:20);
end.
