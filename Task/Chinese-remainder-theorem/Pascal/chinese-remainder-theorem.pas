// Rosetta Code task "Chinese remainder theorem".
program ChineseRemThm;
uses SysUtils;
type TIntArray = array of integer;

// Defining EXTRA adds optional explanatory code
{$DEFINE EXTRA}

// Return (if possible) a residue res_out that satifies
//   res_out = res1 modulo mod1,  res_out = res2 modulo mod2.
// Return mod_out = LCM( mod1, mod2), or mod_out = 0 if there's no solution.
procedure Solve2( const res1, res2, mod1, mod2 : integer;
                  out res_out, mod_out : integer);
var
  a, c, d, k, m, m1, m2, r, temp : integer;
  p, p_prev : integer;
{$IFDEF EXTRA}
  q, q_prev : integer;
{$ENDIF}
begin
  if (mod1 = 0) or (mod2 = 0) then
    raise SysUtils.Exception.Create( 'Solve2: Modulus cannot be 0');
  m1 := Abs( mod1);
  m2 := Abs( mod2);
  // Extended Euclid's algorithm for HCF( m1, m2), except that only one
  //   of the Bezout coefficients is needed (here p, could have used q)
  c := m1; d := m2;
  p :=0;  p_prev := 1;
{$IFDEF EXTRA}
  q := 1; q_prev := 0;
{$ENDIF}
  a := 0;
  while (d > 0) do begin
    temp := p_prev - a*p;  p_prev := p;  p := temp;
  {$IFDEF EXTRA}
    temp := q_prev - a*q;  q_prev := q;  q := temp;
  {$ENDIF}
    a := c div d;
    temp := c - a*d;  c := d;  d := temp;
  end;
  // Here with c = HCF( m1, m2)
{$IFDEF EXTRA}
  Assert( c = p*m2 + q*m1); // p and q are the Bezout coefficients
{$ENDIF}
  // A soution exists iff c divides (res2 - res1)
  k := (res2 - res1) div c;
  if res2 - res1 <> k*c then begin
    res_out := 0;  mod_out := 0; // indicate that there's no xolution
  end
  else begin
    m := (m1 div c) * m2; // m := LCM( m1, m2)
    r:= res2 - k*p*m2;    // r := a solution modulo m
{$IFDEF EXTRA}
    Assert( r = res1 + k*q*m1); // alternative formula in terms of q
{$ENDIF}
    // Return the solution in the range 0..(m - 1)
    // Don't trust the compiler with a negative argument to mod
    if (r >= 0) then r := r mod m
    else begin
      r := (-r) mod m;
      if (r > 0) then r := m - r;
    end;
    res_out := r;  mod_out := m;
  end;
end;

// Return (if possible) a residue res_out that satifies
//   res_out = res_array[j] modulo mod_array[j], for j = 0..High(res_array).
// Return mod_out = LCM of the moduli, or mod_out = 0 if there's no solution.
procedure SolveMulti( const res_array, mod_array : TIntArray;
                      out res_out, mod_out : integer);
var
  count, k, m, r : integer;
begin
  count := Length( mod_array);
  if count <> Length( res_array) then
    raise SysUtils.Exception.Create( 'Arrays are different sizes')
  else if count = 0 then
    raise SysUtils.Exception.Create( 'Arrays are empty');
  k := 1;
  m := mod_array[0];  r := res_array[0];
  while (k < count) and (m > 0) do begin
    Solve2( r, res_array[k], m, mod_array[k], r, m);
    inc(k);
  end;
  res_out := r;  mod_out := m;
end;

// Cosmetic to turn an integer array into a string for printout.
function ArrayToString( a : TIntArray) : string;
var
  j : integer;
begin
  result := '[';
  for j := 0 to High(a) do begin
    result := result + SysUtils.IntToStr(a[j]);
    if j < High(a) then result := result + ', '
                   else result := result + ']';
  end;
end;

// For the passed-in res_array and mod_array, show the solution
//   found by SolveMulti (above), or state that there's no solution.
procedure ShowSolution( const res_array, mod_array : TIntArray);
var
  mod_out, res_out : integer;
begin
  SolveMulti( res_array, mod_array, res_out, mod_out);
  Write( ArrayToString( res_array) + ' mod '
       + ArrayToString( mod_array) + ' --> ');
  if mod_out = 0 then
    WriteLn( 'No solution')
  else
    WriteLn( SysUtils.Format( '%d mod %d', [res_out, mod_out]));
end;

// Main routine. Examples for Rosetta Code task.
begin
  ShowSolution([2, 3, 2], [3, 5, 7]);
  ShowSolution([3, 5, 7], [2, 3, 2]);
  ShowSolution([10, 4, 12], [11, 12, 13]);
  ShowSolution([1, 2, 3, 4], [5, 7, 9, 11]);
  ShowSolution([11, 22, 19], [10, 4, 9]);
  ShowSolution([2328, 410], [16256, 5418]);
  ShowSolution([19, 0], [100, 23]);
end.
