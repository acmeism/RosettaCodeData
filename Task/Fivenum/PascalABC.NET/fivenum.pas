const
  Lists: array of array of real =
        ((15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0),
         (36.0, 40.0, 7.0, 39.0, 41.0, 15.0),
         (0.14082834,  0.09748790,  1.73131507,  0.87636009, -1.95059594,
          0.73438555, -0.03035726,  1.46675970, -0.74621349, -0.72588772,
          0.63905160,  0.61501527, -0.98983780, -1.00447874, -0.62759469,
          0.66206163,  1.04312009, -0.10305385,  0.75775634,  0.32566578));

function median(x: array of real; startIndex, endIndex: integer): real;
begin
  var size := endIndex - startIndex + 1;
  assert(size > 0, 'array slice cannot be empty');
  var m := startIndex + size div 2;
  result := if size mod 2 = 1 then x[m] else (x[m - 1] + x[m]) / 2
end;

function fivenum(x: array of real): array of real;
begin
  setlength(result, 5);
  x := x.Sorted.ToArray;
  var m := x.length div 2;
  var lowerEnd := if x.length mod 2 = 1 then m else m - 1;
  result[0] := x[0];
  result[1] := median(x, 0, lowerEnd);
  result[2] := median(x, 0, x.high);
  result[3] := median(x, m, x.high);
  result[4] := x[^1];
end;

begin
  foreach var list in Lists do
  begin
    println(list.toarray);
    println('  →  ', fivenum(list));
  end;
end.
