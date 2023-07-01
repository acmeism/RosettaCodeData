program Faulhaber;

{$IFDEF FPC} // Lazarus
  {$MODE Delphi} // ensure Lazarus accepts Delphi-style code
  {$ASSERTIONS+} // by default, Lazarus does not compile 'Assert' statements
{$ELSE}     // Delphi
  {$APPTYPE CONSOLE}
{$ENDIF}

uses SysUtils;

type TRational = record
  Num, Den : integer; // where Den > 0 and Num, Den are coprime
end;

const
  ZERO : TRational = ( Num: 0; Den : 1);
  HALF : TRational = ( Num: 1; Den : 2);

// Construct rational a/b, assuming b > 0.
function Rational( const a, b : integer) : TRational;
var
  t, x, y : integer;
begin
  if b <= 0 then raise SysUtils.Exception.Create( 'Denominator must be > 0');
  // Find HCF of a and b (Euclid's algorithm) and cancel it out.
  x := Abs(a);
  y := b;
  while y <> 0 do begin
    t := x mod y;
    x := y;
    y := t;
  end;
  result.Num := a div x;
  result.Den := b div x
end;

function Prod( r, s : TRational) : TRational; // result := r*s
begin
  result := Rational( r.Num*s.Num, r.Den*s.Den);
end;

procedure DecRat( var r : TRational;
                const s : TRational); // r := r - s
begin
  r := Rational( r.Num*s.Den - s.Num*r.Den, r.Den * s.Den);
end;

// Write a term such as ' - (7/10)n^6' to the console.
procedure WriteTerm( coeff : TRational;
                     index : integer;
                     printPlus : boolean);
begin
  if Coeff.Num = 0 then exit;
  with coeff do begin
    if Num < 0 then Write(' - ')
    else if printPlus then Write(' + ');
    // Put brackets round a fractional coefficient
    if (Den > 1) then Write('(');
    // If coefficient is 1, don't write it
    if (Den > 1) or (Abs(Num) > 1) then Write( Abs(Num));
    // Write denominator if it's not 1
    if (Den > 1) then Write('/', Den, ')');
  end;
  Write('n');
  if index > 1 then Write('^', index);
end;

{-------------------------------------------------------------------------------
Main routine. Calculation of Faulhaber polynomials
  F_p(n) = 1^p + 2^p + ... + n^p,  p = 0, 1, ..., p_max
}
var
  p_max : integer;
  c : array of array of TRational;
  i, j, p : integer;
  coeff_of_n : TRational;
begin
  // User types program name, optionally followed by maximum power p (defaults to 9)
  if ParamCount = 0 then p_max := 9
                    else p_max := SysUtils.StrToInt( ParamStr(1));

  // c[p, i] is coefficient of n^i in the polynomial F_p(n).
  // Initialize all coefficients to 0.
  SetLength( c, p_max + 1, p_max + 2);
  for i := 0 to p_max do
    for j := 0 to p_max + 1 do
      c[i, j] := ZERO;

  c[0, 1] := Rational(1, 1); // F_0(n) = n, special case
  for p := 1 to p_max do begin
    // Initialize calculation of coefficient of n, needed if p is even.
    // If p is odd, still calculate it as a check on the working (should be 0).
    // Calculation uses the fact that F_p(1) = 1.
    coeff_of_n := Rational(1, 1);

    c[p, p+1] := Rational(1, p + 1);
    DecRat( coeff_of_n, c[p, p + 1]);
    c[p, p] := HALF;
    DecRat( coeff_of_n, c[p, p]);
    i := p - 1;
    while (i >= 2) do begin
      c[p, i] := Prod( Rational(p, i), c[p - 1, i - 1]);
      DecRat( coeff_of_n, c[p, i]);
      dec(i, 2);
    end;
    if i = 1 then // p is even
      c[p, 1] := coeff_of_n // = the Bernoulli number B_p
    else // p is odd
      Assert( coeff_of_n.Num = 0); // just checking
  end; // for p

  // Print the result
  for p := 0 to p_max do begin
    Write( 'F_', p, '(n) = ');
    for j := p + 1 downto 1 do WriteTerm( c[p, j], j, j <= p);
    WriteLn;
  end;
end.
