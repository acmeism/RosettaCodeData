program LempelZiv;

{$IFDEF FPC}  // if Free Pascal Compiler
  {$MODE Delphi}
{$ELSE}       // if not FPC, assume Delphi
  {$APPTYPE CONSOLE}
{$ENDIF}

{$DEFINE SIMPLE_BUT_SLOW} // comment out to run faster version

function LZComplexity( const s : string;
                       out hist : string) : integer;
{$IFDEF SIMPLE_BUT_SLOW}
var
  j : integer;
  left, right, prev : string;
begin
  result := 0;
  hist := '';
  left := '';
  right := '';
  for j := 1 to Length(s) do begin
    if right = '' then inc( result); // starting a new component
    prev := left + right;
    right := right + s[j];
    if Pos( right, prev) = 0 then begin // if right isn't a substring of prev
      hist := hist + right + '.';
      left := left + right;
      right := '';
    end;
  end;
  hist := hist + right; // append non-exhaustive component, if there is one
end;
{$ELSE} // faster version
var
  h, i, k, n, p, r : integer;
// s[1..r-1] and s[r..k] correspond to "left" and "right" of simpler version.
  foundMatch : boolean;
begin
  result := 0;
  n := Length(s);
  SetLength( hist, 2*n); // may be reduced later
  h := 0; // index into hist, pre-inc'd
  r := 1; // left := '', right = ''
  p := 0; // like Delphi Pos: index of matching substring, 0 if none
  for k := 1 to n do begin
    inc(h); hist[h] := s[k];
    if k = r then inc( result); // starting a new component

    // Test whether s[1..k-1] contains a substring matchimg s[r..k].
    // Note that if the previous iteration found a match at p > 0 then
    // (1) the substring at p still matches, except maybe the last character;
    // (2) any match on this iteration must begin at or after p.
    if (p > 0) and (s[k] = s[k + p - r]) then
      foundMatch := true // can extend match from previous iteration
    else if p >= r - 1 then
      foundMatch := false // no more substrings to try
    else begin
      inc(p); // try substrings at p + 1, ..., r - 1
      repeat
        i := r;
        while (i <= k) and (s[i] = s[i + p - r]) do inc(i);
        if i <= k then inc(p);
      until (i > k) or (p = r);
      foundMatch := (p < r);
    end;
    if not foundMatch then begin
      inc(h); hist[h] := '.';
      r := k + 1;
      p := 0;
    end;
  end; // for
  SetLength( hist, h); // discard unused part of history string
end;
{$ENDIF} // end of faster version

type TLZTest = record
  Input : string;
  Comp : integer;
end;
const
  TESTS : array[1..18] of TLZTest =
((Input: 'AZSEDRFTGYGUJIJOKB'; Comp: 16),
 (Input: 'ABCABCABCABCABCABC'; Comp: 4),
 (Input: '111011111001111011111001'; Comp: 6),
 (Input: '101001010010111110'; Comp: 5),
 (Input: '1001111011000010'; Comp: 6),
 (Input: '1010101010'; Comp: 3),
 (Input: '1010101010101010'; Comp: 3),
 (Input: '1001111011000010000010'; Comp: 7),
 (Input: '100111101100001000001010'; Comp: 8),
 (Input: '0001101001000101'; Comp: 6),
 (Input: '1111111'; Comp: 2),
 (Input: '0001'; Comp: 2),
 (Input: '010'; Comp: 3),
 (Input: '1'; Comp: 1),
 (Input: ''; Comp: 0),
 (Input: '01011010001101110010'; Comp: 7),
 (Input: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'; Comp: 26),
 (Input: 'HELLO WORLD! HELLO WORLD! HELLO WORLD! HELLO WORLD!'; Comp: 11));

var
  t, myComp, nrDiff : integer;
  hist : string;
begin
  WriteLn( 'Checking complexity against task description:');
  nrDiff := 0;
  for t := Low( TESTS) to High( TESTS) do begin
    with TESTS[t] do begin
      myComp := LZComplexity( Input, hist);
      WriteLn( '"', hist, '"  ', myComp);
      if myComp <> Comp then begin
        inc( nrDiff);
        WriteLn( '*** Task description has ', Comp);
      end;
    end;
  end;
  WriteLn( 'Number of differences = ', nrDiff);
end.
