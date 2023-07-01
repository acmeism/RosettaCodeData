program BurrowsWheeler;

{$mode objfpc}{$H+}  // Lazarus default mode; long strings
uses SysUtils;       // only for console output
const STR_BASE = 1;  // first character in a Pascal string has index [1].
type TComparison = -1..1;

procedure Encode( const input : string;
                  out encoded : string;
                  out index : integer);
var
  n : integer;
  perm : array of integer;
  i, j, k : integer;
  incr, v : integer;

        // Subroutine to compare rotations whose *last* letters have zero-based
        //  indices a, b. Returns 1, 0, -1 according as the rotation ending at a
        //  is >, =, < the rotation ending at b.
        function CompareRotations( a, b : integer) : TComparison;
        var
          p, q, nrNotTested : integer;
        begin
          result := 0;
          p := a;
          q := b;
          nrNotTested := n;
          repeat
            inc(p); if (p = n) then p := 0;
            inc(q); if (q = n) then q := 0;
            if (input[p + STR_BASE] = input[q + STR_BASE]) then dec( nrNotTested)
            else if (input[p + STR_BASE] > input[q + STR_BASE]) then result := 1
            else result := -1
          until (result <> 0) or (nrNotTested = 0);
        end;
begin
  n := Length( input);
  SetLength( perm, n);
  for j := 0 to n - 1 do perm[j] := j;

  // Sort string indices by comparing the associated rotations, as above.
  // This is a Shell sort from Press et al., Numerical Recipes, 3rd edn, pp 422-3.
  // Other sorting algorithms might be used.
  incr := 1;
  repeat
    incr := 3*incr + 1
  until (incr >= n);
  repeat
    incr := incr div 3;
    for i := incr to n - 1 do begin
      v := perm[i];
      j := i;
      while (j >= incr) and (CompareRotations( perm[j - incr], v) = 1) do begin
        perm[j] := perm[j - incr];
        dec( j, incr);
      end;
      perm[j] := v;
    end; // for
  until (incr = 1);

  // Apply the sorted array to create the output.
  SetLength( encoded, n);
  for j := 0 to n - 1 do begin
    k := perm[j];
    encoded[j + STR_BASE] := input[k + STR_BASE];
    if (k = n - 1) then index := j;
  end;
end;

{------------------------------------------------------------------------------
Given an encoded string and the associated index, one way to rebuild
the original string is to do the following, or its equivalent:

Given        Make an array     Sort the array    Rebuild the original string
'NNBAAA'     [0] = ('N', 0)    [0] = ('A', 3)    Start with given index 3
index = 3    [1] = ('N', 1)    [1] = ('A', 4)    [3] gives 'B', next index = 2
             [2] = ('B', 2)    [2] = ('A', 5)    [2] gives 'A', next index = 5
             [3] = ('A', 3)    [3] = ('B', 2)    [5] gives 'N', next index = 1
             [4] = ('A', 4)    [4] = ('N', 0)    [1] gives 'A', next index = 4
             [5] = ('A', 5)    [5] = ('N', 1)    [4] gives 'N', next index = 0
                                                 [0] gives 'A', next index = 3
                                                 3 = start index, so stop
                                                 Result = 'BANANA'

If the original string consists of two or more repetitions of a substring,
  the above method will stop when that substring has been built, e.g.
  'CANCAN' will stop at 'CAN'.
We therefore need to test for the rebuilt string being too short, and if so
  make enough copies of the decoded part to fill the required length.

It's possible to take the above description literally, and write a decoding
  routine that uses a record type consisting of a character and an integer.
A more efficient way is to create an integer array containing only the indices,
  in the above example (3, 4, 5, 2, 0, 1). A first pass counts the occurrences
  of each character in the encoded string. If the character set is ['A'..'Z']
  then the indices associated with 'A' are stored from [0]. If 'A' occurs a times,
  the indices associated with 'B' are stored from [a]; if 'B' occurs b times,
  the indices associated with 'C' are stored from [a + b]; and so on.
}
function Decode( encoded : string;
                 index : integer) : string;
var
  charInfo : array [char] of integer;
  perm : array of integer;
  n, j, k : integer;
  c : char;
  total, prev : integer;

begin
  n := Length( encoded);
  // An empty encoded string will crash the code below, so trap it here.
  if (n = 0) then begin
    result := '';
    exit;
  end;

  // Count the occurrences of each possible character.
  for c := Low(char) to High(char) do charInfo[c] := 0;
  for j := 0 to n - 1 do begin
    c := encoded[j + STR_BASE];
    inc( charInfo[c]);
  end;

  // Cumulate, i.e. charInfo[k] := sum of old charInfo from 0 to k - 1
  total := 0;
  prev := 0;
  for c := Low(char) to High(char) do begin
    inc( total, prev);
    prev := CharInfo[c];
    charInfo[c] := total;
  end;

  // Make the array "perm"
  SetLength( perm, n);
  for j := 0 to n - 1 do begin
    c := encoded[j + STR_BASE];
    k := charInfo[c];
    perm[k] := j;
    inc( charInfo[c]);
  end;

  // Apply the array "perm" to re-create the original string.
  SetLength( result, n);
  k := 0; // index into result
  j := index;
  repeat
    j := perm[j];
    result[k + STR_BASE] := encoded[j + STR_BASE];
    inc(k);
  until (j = index);

  // If the original consisted of M repetitions of the same string, then
  //   at this point exactly 1/M of the result has been filled in.
  // For M > 1 (shown by k < n), complete the result by copying the first part.
  if (k < n) then begin
    Assert( n mod k = 0); // we should have n = M*k
    for j := k to n - 1 do result[j + STR_BASE] := result[j - k + STR_BASE];
  end;
end;

procedure Test( const s : string);
var
  encoded, decoded : string;
  index : integer;
begin
  WriteLn( '');
  WriteLn( '     ' + s);
  Encode( s, {out} encoded, index);
  WriteLn( '---> ' + encoded);
  WriteLn( '       index = ' + SysUtils.IntToStr( index));
  decoded := Decode( encoded, index);
  WriteLn( '---> ' + decoded);
end;

begin
  Test( 'BANANA');
  Test( 'CANAAN');
  Test( 'CANCAN');
  Test( 'appellee');
  Test( 'dogwood');
  Test( 'TO BE OR NOT TO BE OR WANT TO BE OR NOT?');
  Test( 'SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES');
end.
