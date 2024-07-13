function Lengths(x,y: string): array[,] of integer;
begin
  var (m,n) := (x.Length,y.Length);
  var C := new integer[m+1, n+1]; // filled with zeroes
  for var i:=1 to m do
  for var j:=1 to n do
    if x[i] = y[j] then
      C[i,j] := C[i-1,j-1] + 1
    else C[i,j] := max(C[i,j-1], C[i-1,j]);
  Result := C;
end;

function lcshelper(x,y: string; i,j: integer): string;
begin
  var C := Lengths(x,y);
  if (i = 0) or (j = 0) then
    Result := ''
  else if  X[i] = Y[j] then
    Result := lcshelper(X, Y, i-1, j-1) + X[i]
  else if C[i,j-1] > C[i-1,j] then
    Result := lcshelper(X, Y, i, j-1)
  else Result := lcshelper(X, Y, i-1, j)
end;

function lcs(x,y: string) := lcshelper(x,y,x.Length,y.Length);

begin
  Println(lcs('1234','1224533324'));
  Println(lcs('thisisatest','testing123testing'));
end.
