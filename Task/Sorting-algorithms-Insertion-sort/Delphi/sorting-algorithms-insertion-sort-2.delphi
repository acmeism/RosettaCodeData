procedure InsertionSort(var S: string);
var
  I, J, L: Integer;
  Ch: Char;

begin
  L:= Length(S);
  for I:= 2 to L do begin
    Ch:= S[I];
    J:= I - 1;
    while (J > 0) and (S[J] > Ch) do begin
      S[J + 1]:= S[J];
      Dec(J);
    end;
    S[J + 1]:= Ch;
  end;
end;
