program deBruijnSequence;
uses SysUtils;

// Create a de Bruijn sequence for the given word length and alphabet.
function deBruijn( const n : integer; // word length
                   const alphabet : string) : string;
var
  d, k, m, s, t, seqLen : integer;
  w : array of integer;
begin
  k := Length( alphabet);
  // de Bruijn sequence will have length k^n
  seqLen := 1;
  for t := 1 to n do seqLen := seqLen*k;
  SetLength( result, seqLen);
  d := 0; // index into de Bruijn sequence (will be pre-inc'd)
  // Work through Lyndon words of length <= n, in lexicographic order.
  SetLength( w, n); // w holds array of indices into the alphabet
  w[0] := 1; // first Lyndon word
  m := 1; // m = length of Lyndon word
  repeat
    // If m divides n, append the current Lyndon word to the output
    if (m = n) or (m = 1) or (n mod m = 0) then begin
      for t := 0 to m - 1 do begin
        inc(d);
        result[d] := alphabet[w[t]];
      end;
    end;
    // Get next Lyndon word using Duval's algorithm:
    // (1) Fill w with repetitions of current word
    s := 0; t := m;
    while (t < n) do begin
      w[t] := w[s];
      inc(t);  inc(s);
      if s = m then s := 0;
    end;
    // (2) Repeatedly delete highest index k from end of w, if present
    m := n;
    while (m > 0) and (w[m - 1] = k) do dec(m);
    // (3) If word is now null, stop; else increment end value
    if m > 0 then inc( w[m - 1]);
  until m = 0;
  Assert( d = seqLen); // check that the sequence is exactly filled in
end;

// Check a de Bruijn sequence, assuming that its alphabet consists
//  of the digits '0'..'9' (in any order);
procedure CheckDecimal( const n : integer; // word length
                        const deB : string);
var
  count : array of integer;
  j, L, pin, nrErrors : integer;
  wrap : string;
begin
  L := Length( deB);
  // The de Bruijn sequence is cyclic; make an array to handle wrapround.
  SetLength( wrap, 2*n - 2);
  for j := 1 to n - 1 do wrap[j] := deB[L + j - n  + 1];
  for j := n to 2*n - 2 do wrap[j] := deB[j - n + 1];
  // Count occurrences of each PIN.
  // PIN = -1 if character is not a decimal digit.
  SetLength( count, L);
  for j := 0 to L - 1 do count[L] := 0;
  for j := 1 to L - n + 1 do begin
    pin := SysUtils.StrToIntDef( Copy( deB, j, n), -1);
    if pin >= 0 then inc( count[pin]);
  end;
  for j := 1 to n - 1 do begin
    pin := SysUtils.StrToIntDef( Copy( wrap, j, n), -1);
    if pin >= 0 then inc( count[pin]);
  end;
  // Check that all counts are 1
  nrErrors := 0;
  for j := 0 to L - 1 do begin
    if count[j] <> 1 then begin
      inc( nrErrors);
      WriteLn( SysUtils.Format( '  PIN %d has count %d', [j, count[j]]));
    end;
  end;
  WriteLn( SysUtils.Format( '  Number of errors = %d', [nrErrors]));
 end;

// Main routine
var
  deB, rev : string;
  L, j : integer;
begin
   deB := deBruijn( 4, '0123456789');
//   deB := deBruijn( 4, '7368290514'); // any permutation would do
   L := Length( deB);
   WriteLn( SysUtils.Format( 'Length of de Bruijn sequence = %d', [L]));
   if L >= 260 then begin
     WriteLn;
     WriteLn( 'First and last 130 characters are:');
     WriteLn( Copy( deB, 1, 65));
     WriteLn( Copy( deb, 66, 65));
     WriteLn( '...');
     WriteLn( Copy( deB, L - 129, 65));
     WriteLn( Copy( deB, L - 64, 65));
   end;
   WriteLn;
   WriteLn( 'Checking de Bruijn sequence:');
   CheckDecimal( 4, deB);
   // Check reversed sequence
   SetLength( rev, L);
   for j := 1 to L do rev[j] := deB[L + 1 - j];
   WriteLn( 'Checking reversed sequence:');
   CheckDecimal( 4, rev);
   // Check sequence with '.' instad of decimal digit
   if L >= 4444 then begin
     deB[4444] := '.';
     WriteLn( 'Checking vandalized sequence:');
     CheckDecimal( 4, deB);
   end;
end.
