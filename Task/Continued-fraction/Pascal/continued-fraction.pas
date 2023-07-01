program ContFrac_console;

{$APPTYPE CONSOLE}

uses
  SysUtils;

type TCoeffFunction = function( n : integer) : extended;

// Calculate continued fraction as a sum, working forwards.
// Stop on reaching a term with absolute value less than epsilon,
//   or on reaching the maximum number of terms.
procedure CalcContFrac( a, b : TCoeffFunction;
                        epsilon : extended;
                        maxNrTerms : integer = 1000); // optional, with default
var
  n : integer;
  sum, term, u, v : extended;
  whyStopped : string;
begin
  sum := a(0);
  term := b(1)/a(1);
  v := a(1);
  n := 1;
  repeat
    sum := sum + term;
    inc(n);
    u := v;
    v := a(n) + b(n)/u;
    term := -term * b(n)/(u*v);
  until (Abs(term) < epsilon) or (n >= maxNrTerms);
  if n >= maxNrTerms then whyStopped := 'too many terms'
                     else whyStopped := 'converged';
  WriteLn( SysUtils.Format( '%21.17f after %d terms (%s)',
                            [sum, n, whyStopped]));
end;

//---------------- a and b for sqrt(2) ----------------
function a_sqrt2( n : integer) : extended;
begin
  if n = 0 then result := 1
           else result := 2;
end;
function b_sqrt2( n : integer) : extended;
begin
  result := 1;
end;

//---------------- a snd b for e  ----------------
function a_e( n : integer) : extended;
begin
  if n = 0 then result := 2
           else result := n;
end;
function b_e( n : integer) : extended;
begin
  if n = 1 then result := 1
           else result := n - 1;
end;

//-------- Rosetta Code a and b for pi --------
function a_pi( n : integer) : extended;
begin
  if n = 0 then result := 3
           else result := 6;
end;
function b_pi( n : integer) : extended;
var
  temp : extended;
begin
  temp := 2*n - 1;
  result := temp*temp;
end;

//-------- More efficient a and b for pi --------
function a_pi_alt( n : integer) : extended;
begin
  if n = 0 then result := 0
           else result := 2*n - 1;
end;
function b_pi_alt( n : integer) : extended;
var
  temp : extended;
begin
  if n = 1 then
    result := 4
  else begin
    temp := n - 1;
    result := temp*temp;
  end;
end;

//---------------- Main routine ----------------
// Unlike Free Pascal, Delphi does not require
//   an @ sign before the function names.
begin
  WriteLn( 'sqrt(2)');
  CalcContFrac( a_sqrt2, b_sqrt2, 1E-20);
  WriteLn( 'e');
  CalcContFrac( a_e, b_e, 1E-20);
  WriteLn( 'pi');
  CalcContFrac( a_pi, b_pi, 1E-20);
  WriteLn( 'pi (alternative formula)');
  CalcContFrac( a_pi_alt, b_pi_alt, 1E-20);
end.
