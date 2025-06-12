program LevenshteinDistanceDemo(Output);

uses
  Math;

  function LevenshteinDistance(S, T: string): longint;
  var
    D: array of array of integer;
    I, J, N, M: integer;
  begin
    N := Length(T);
    M := Length(S);
    SetLength(D, M + 1, N + 1);

    for I := 0 to M do
      D[I, 0] := I;
    for J := 0 to N do
      D[0, J] := J;
    for J := 1 to N do
      for I := 1 to M do
        if S[I] = T[J] then
          D[I, J] := D[I - 1, J - 1]
        else
          D[I, J] := Min(D[I - 1, J] + 1, Min(D[I, J - 1] + 1, D[I - 1, J - 1] + 1));
    LevenshteinDistance := D[M, N];
  end;

var
  S1, S2: string;

begin
  S1 := 'kitten';
  S2 := 'sitting';
  WriteLn('The Levenshtein distance between "', S1, '" and "',
    S2, '" is: ', LevenshteinDistance(S1, S2));
  S1 := 'rosettacode';
  S2 := 'raisethysword';
  WriteLn('The Levenshtein distance between "', S1, '" and "',
    S2, '" is: ', LevenshteinDistance(S1, S2));
end.
