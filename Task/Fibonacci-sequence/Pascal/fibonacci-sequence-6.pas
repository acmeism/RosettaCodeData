program Fibonacci_console;

{$mode objfpc}{$H+}

uses SysUtils;

function Fibonacci( n : word) : uint64;
{
Starts with the pair F[0],F[1]. At each iteration, uses the doubling formulae
to pass from F[k],F[k+1] to F[2k],F[2k+1]. If the current bit of n (starting
from the high end) is 1, there is a further step to F[2k+1],F[2k+2].
}
var
  marker, half_n : word;
  f, g : uint64; // pair of consecutive Fibonacci numbers
  t, u : uint64; // -----"-----
begin
  // The values of F[0], F[1], F[2]  are assumed to be known
  case n of
    0 : result := 0;
    1, 2 : result := 1;
    else begin
      half_n := n shr 1;
      marker := 1;
      while marker <= half_n do marker := marker shl 1;

      // First time: current bit is 1 by construction,
      //   so go straight from F[0],F[1] to F[1],F[2].
      f := 1; // = F[1]
      g := 1; // = F[2]
      marker := marker shr 1;

      while marker > 1 do begin
        t := f*(2*g - f);
        u := f*f + g*g;
        if (n and marker = 0) then begin
          f := t;
          g := u;
        end
        else begin
          f := u;
          g := t + u;
        end;
        marker := marker shr 1;
      end;

      // Last time: we need only one of the pair.
      if (n and marker = 0) then
        result := f*(2*g - f)
      else
        result := f*f + g*g;
    end; // end else (i.e. n > 2)
  end; // end case
end;

// Main program
var
  n : word;
begin
  for n := 0 to 93 do
    WriteLn( SysUtils.Format( 'F[%2u] = %20u', [n, Fibonacci(n)]));
end.
