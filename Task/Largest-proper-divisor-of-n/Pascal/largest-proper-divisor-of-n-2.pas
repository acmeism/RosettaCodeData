program LPD;
(*
Displays largest proper divisor for each integer in range 1..limit.
Command line:
      LPD limit items_per_line
  or  LPD limit // items_per_line defaults to 10
  or  LPD       // limit defaults to 100
*)
{$mode objfpc}{$H+}

uses SysUtils;
var
  limit, items_per_line, nr_items, j, p : integer;
  a : array of integer;
begin
  // Set up defaults
  limit := 100;
  items_per_line := 10;
  // Overwrite defaults with command-line parameters, if present
  if ParamCount > 0 then
    limit := SysUtils.StrToInt( ParamStr(1));
  if ParamCount > 1 then
    items_per_line := SysUtils.StrToInt( ParamStr(2));
  WriteLn( 'Largest proper divisors 1..', limit);
  // Dynamic arrays are 0-based. To keep it simple, we ignore a[0]
  //  and use a[j] for the integer j, 1 <= j <= limit
  SetLength( a, limit + 1);
  for j := 1 to limit do a[j] := 1; // stays at 1 if j is 1 or prime

  // Sieve; if j is composite then a[j] := smallest prime factor of j
  p := 2; //  p = next prime
  while p*p < limit do begin
    j := 2*p;
    while j <= limit do begin
      if a[j] = 1 then a[j] := p;
      inc( j, p);
    end;
    repeat
      inc(p);
    until (p > limit) or (a[p] = 1);
  end;

  // If j is composite, divide j by its smallest prime factor
  for j := 1 to limit do
    if a[j] > 1 then a[j] := j div a[j];

  // Write the array to the console
  nr_items := 0;
  for j := 1 to limit do begin
    Write( a[j]:5);
    inc( nr_items);
    if nr_items = items_per_line then begin
      WriteLn;
      nr_items := 0;
    end;
  end;
  if nr_items > 0 then WriteLn;
end.
