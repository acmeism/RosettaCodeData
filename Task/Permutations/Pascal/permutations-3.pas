program Permutations;
(*
Demonstrates four closely related ways of establishing a bijection between
permutations of 0..(n-1) and integers 0..(n! - 1).
Each integer in that range is represented by mixed-base digits d[0..n-1],
where each d[j] satisfies 0 <= d[j] <=j.
The integer represented by d[0..n-1] is
  d[n-1]*(n-1)! + d[n-2]*(n-2)! + ... + d[1]*1! + d[0]*0!
where the last term can be omitted in practice because d[0] is always 0.
See the section "Numbering permutations" in the Wikipedia article
"Permutation" (NB their digit array d is 1-based).
*)
uses SysUtils, TypInfo;
type TPermIntMapping = (map_I, map_J, map_K, map_L);
type TPermutation = array of integer;

// Function to map an integer to a permutation.
function IntToPerm( map : TPermIntMapping;
                    nrItems, z : integer) : TPermutation;
var
  d, lookup : array of integer;
  x, y : integer;
  h, j, k, m : integer;
begin
  SetLength( result, nrItems);
  SetLength( lookup, nrItems);
  SetLength( d, nrItems);
  m := nrItems - 1;
  // Convert z to digits d[0..m] (see comment at head of program).
  d[0] := 0;
  y := z;
  for j := 1 to m - 1 do begin
    x := y div (j + 1);
    d[j] := y - x*(j + 1);
    y := x;
  end;
  d[m] := y;

  // Set up the permutation elements
  case map of
    map_I, map_L: for j := 0 to m do lookup[j] := j;
    map_J, map_K: for j := 0 to m do lookup[j] := m - j;
  end;
  for j := m downto 0 do begin
    k := d[j];
    case map of
      map_I: result[lookup[k]] := m - j;
      map_J: result[j] := lookup[k];
      map_K: result[lookup[k]] := j;
      map_L: result[m - j] := lookup[k];
    end;
    // When lookup[k] has been used, it's removed from the lookup table
    //   and the elements above it are moved down one place.
    for h := k to j - 1 do lookup[h] := lookup[h + 1];
  end;
end;

// Function to map a permutation to an integer; inverse of the above.
// Put in for completeness, not required for Rosetta Code task.
function PermToInt( map : TPermIntMapping;
                    p : TPermutation) : integer;
var
  m, i, j, k : integer;
  d : array of integer;
begin
  m := High(p); // number of items in permutation is m + 1
  SetLength( d, m + 1);
  for k := 0 to m do d[k] := 0; // initialize all digits to 0

  // Looking for inversions
  for i := 0 to m - 1 do begin
    for j := i + 1 to m do begin
      if p[j] < p[i] then begin
        case map of
          map_I : inc( d[m - p[j]]);
          map_J : inc( d[j]);
          map_K : inc( d[p[i]]);
          map_L : inc( d[m - i]);
        end;
      end;
    end;
  end;
  // Get result from its digits (see comment at head of program).
  result := d[m];
  for j := m downto 2 do result := result*j + d[j - 1];
end;

// Main routine to generate permutations of the integers 0..(n-1),
// where n is passed as a command-line parameter, e.g. Permutations 4
var
  n, n_fac, z, j : integer;
  nrErrors : integer;
  perm : TPermutation;
  map : TPermIntMapping;
  lineOut : string;
  pinfo : TypInfo.PTypeInfo;
begin
  n := SysUtils.StrToInt( ParamStr(1));
  n_fac := 1;
  for j := 2 to n do n_fac := n_fac*j;
  pinfo := System.TypeInfo( TPermIntMapping);
  lineOut := 'integer';
  for map := Low( TPermIntMapping) to High( TPermIntMapping) do begin
    lineOut := lineOut + '   ' + TypInfo.GetEnumName( pinfo, ord(map));
  end;
  WriteLn( lineOut);
  for z := 0 to n_fac - 1 do begin
    lineOut := SysUtils.Format( '%7d', [z]);
    for map := Low( TPermIntMapping) to High( TPermIntMapping) do begin
      perm := IntToPerm( map, n, z);
      // Check the inverse mapping (not required for Rosetta Code task)
      Assert( z = PermToInt( map, perm));
      lineOut := lineOut + '    ';
      for j := 0 to n - 1 do
        lineOut := lineOut + SysUtils.Format( '%d', [perm[j]]);
    end;
    WriteLn( lineOut);
  end;
end.
