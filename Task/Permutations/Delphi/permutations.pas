program TestPermutations;

{$APPTYPE CONSOLE}

type
  TItem = Integer;                // declare ordinal type for array item
  TArray = array[0..3] of TItem;

const
  Source: TArray = (1, 2, 3, 4);

procedure Permutation(K: Integer; var A: TArray);
var
  I, J: Integer;
  Tmp: TItem;

begin
  for I:= Low(A) + 1 to High(A) + 1 do begin
    J:= K mod I;
    Tmp:= A[J];
    A[J]:= A[I - 1];
    A[I - 1]:= Tmp;
    K:= K div I;
  end;
end;

var
  A: TArray;
  I, K, Count: Integer;
  S, S1, S2: ShortString;

begin
  Count:= 1;
  I:= Length(A);
  while I > 1 do begin
    Count:= Count * I;
    Dec(I);
  end;

  S:= '';
  for K:= 0 to Count - 1 do begin
    A:= Source;
    Permutation(K, A);
    S1:= '';
    for I:= Low(A) to High(A) do begin
      Str(A[I]:1, S2);
      S1:= S1 + S2;
    end;
    S:= S + '  ' + S1;
    if Length(S) > 40 then begin
      Writeln(S);
      S:= '';
    end;
  end;

  if Length(S) > 0 then Writeln(S);
  Readln;
end.
