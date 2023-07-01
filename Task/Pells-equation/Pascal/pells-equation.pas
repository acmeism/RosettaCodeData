program Pell_console;
uses SysUtils,
     uIntX; // uIntX is a unit in the library IntXLib4Pascal.
            // uIntX.TIntX is an arbitrarily large integer.

// For the given n: if there are non-trivial solutions of x^2 - n*y^2 = 1
//   in non-negative integers (x,y), return the smallest.
// Else return the trivial solution (x,y) = (1,0).
procedure SolvePell( n : integer; out x, y : uIntX.TIntX);
var
  m, a, c, d : integer;
  p, q, p_next, q_next, p_prev, q_prev : uIntX.TIntX;
  evenNrSteps : boolean;
begin
  if (n >= 0) then m := Trunc( Sqrt( 1.0*n + 0.5)) // or use Rosetta Code Isqrt
              else m := 0;
  if n <= m*m then begin    // if n is not a positive non-square
    x := 1;  y := 0;  exit; // return a trivial solution
  end;
  c := m;  d := 1;
  p := 1;  q := 0;
  p_prev := 0;  q_prev := 1;
  a := m;
  evenNrSteps := true;
  repeat
    // Get the next convergent p/q in the continued fraction for sqrt(n)
    p_next := a*p + p_prev;
    q_next := a*q + q_prev;
    p_prev := p;  p := p_next;
    q_prev := q;  q := q_next;
    // Get the next term a in the continued fraction for sqrt(n)
    Assert((n - c*c) mod d = 0); // optional sanity check
    d := (n - c*c) div d;
    a := (m + c) div d;
    c := a*d - c;
    evenNrSteps := not evenNrSteps;
  until (c = m) and (d = 1);
{
  If the first return to (c,d) = (m,1) occurs after an even number of steps,
    then p^2 - n*q^2 = 1, and there is no solution to x^2 - n*y^2 = -1.
  Else p^2 - n*q^2 = -1, and to get a solution to x^2 - n*y^2 = 1 we can
    either continue until we return to (c,d) = (m,1) for the second time,
    or use the short cut below.
}
  if evenNrSteps then begin
    x := p;  y := q;
  end
  else begin
    x := 2*p*p + 1;  y := 2*p*q
  end;
end;

// For the given n: show the Pell solution on the console.
procedure ShowPellSolution( n : integer);
var
  x, y : uIntX.TIntX;
  lineOut : string;
begin
  SolvePell( n, x, y);
  lineOut := SysUtils.Format( 'n = %d --> (', [n]);
  lineOut := lineOut + x.ToString + ', ' + y.ToString + ')';
  WriteLn( lineOut);
end;

// Main routine
begin
    ShowPellSolution( 61);
    ShowPellSolution( 109);
    ShowPellSolution( 181);
    ShowPellSolution( 277);
end.
