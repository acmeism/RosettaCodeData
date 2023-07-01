program Derangements_RC;
(*
Pascal solution for Rosetta Code task "Permutations/Derangements"
Console program written in Free Pascal (Lazarus)
*)
// Returns first derangement in lexicographic order.
// Function return is false if there are no derangements.
function FirstDerangement( var val : array of integer) : boolean;
var
  n, j : integer;
begin
  n := Length( val);
  result := (n <> 1);
  if n < 2 then exit;
  if Odd(n) then begin
    val[n - 3] := n - 2;
    val[n - 2] := n - 1;
    val[n - 1] := n - 3;
    dec( n, 3);
  end;
  j := 0;
  while (j < n) do begin
    val[j] := j + 1;
    val[j + 1] := j;
    inc( j, 2);
  end;
end;

// Returns next derangement in lexicographic order.
// Function return is false if there are no more derangements.
// Finds next derangement directly, i.e. not by generating
//   permutations until a derangement is found.
function NextDerangement( var val : array of integer) : boolean;
var
  i, j, n : integer;
  backward, done : boolean;
  free : array of boolean;
begin
  n := Length( val);
  if (n < 3) then begin
    result := false;
    exit;
  end;
  SetLength( free, n);
  for j := 0 to n - 1  do free[j] := false;
  i := n - 1;
  free[val[i]] := true;
  backward := true;
  done := false;
  repeat
    if backward then begin
      dec(i);  j := val[i];  free[j] := true;
    end
    else begin
      inc(i);  j := -1;
    end;
    repeat
      inc(j)
    until (j >= n) or (free[j] and (j <> i));
    if (j < n) then begin // found a suitable free value
      val[i] := j;  free[j] := false;
      if (i = n - 1) then done := true // found the next derangement
      else backward := false;
    end
    else if (i = 0) then done := true // no more derangements
    else backward := true;
  until done;
  result := (i > 0);
end;

// Finds all derangements of integers 0..(n - 1) and
//   returns the number of derangements.
// if boolean "show" is true, writes derangments to standard output.
function FindDerangements( n : integer;
                           show : boolean) : integer;
var
  int_array : array of integer;
  j : integer;
  ok : boolean;
begin
  result := 0;
  if (n < 0) then exit;
  SetLength( int_array, n);
  ok := FirstDerangement( int_array);
  while ok do begin
    inc( result);
    if show then begin
      for j := 0 to n - 1 do Write( ' ', int_array[j]);
      WriteLn();
    end;
    ok := NextDerangement( int_array);
  end;
end;

// Returns subfactorial of passed-in integer.
function Subfactorial( n : integer) : uint64;
var
  j : integer;
begin
  result := 1;
  for j := 1 to n do begin
    result := result*j;
    if Odd(j) then dec(result) else inc(result);
  end;
end;

// Main routine for Rosetta Code task.
var
  n, nrFound, nrCalc : integer;
begin
  WriteLn( 'Derangements of 4 integers');
  nrFound := FindDerangements( 4, true);
  WriteLn( 'Number of derangements found = ', nrFound);
  WriteLn();
  WriteLn( 'Number of derangements');
  WriteLn( '  n   Found    Subfactorial');
  for n := 0 to 9 do begin
    nrFound := FindDerangements( n, false);
    nrCalc  := Subfactorial( n);
    WriteLn( n:3, nrFound:8, nrCalc:8);
  end;
  WriteLn();
  WriteLn( 'Subfactorial(20) = ', Subfactorial(20));
end.
