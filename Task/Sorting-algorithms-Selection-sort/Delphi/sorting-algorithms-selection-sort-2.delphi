procedure SelectionSort(var S: string);
var
  Lowest: Char;
  I, J, M, L: Integer;

begin
  L:= Length(S);
  for I:= 1 to L - 1 do begin
    M:= I;
    for J:= I + 1 to L do
      if S[J] < S[M] then M:= J;
    Lowest:= S[M];
    S[M]:= S[I];
    S[I]:= Lowest;
  end;
end;
