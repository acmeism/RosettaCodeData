program BellNumbers;

// For Rosetta Code.
// Delphi console application to display the Bell numbers B_0, ..., B_25.
// Uses signed 64-bit integers, the largest integer type available in Delphi.

{$APPTYPE CONSOLE}

uses SysUtils; // only for the display

const
  MAX_N = 25; // maximum index of Bell number within the limits of int64
var
  n : integer; // index of Bell number
  j : integer; // loop variable
  a : array [0..MAX_N - 1] of int64; // working array to build up B_n

  { Subroutine to display that a[0] is the Bell number B_n }
  procedure Display();
  begin
    WriteLn( SysUtils.Format( 'B_%-2d = %d', [n, a[0]]));
  end;

(* Main program *)
begin
  n := 0;
  a[0] := 1;
  Display(); // some programmers would prefer Display;
  while (n < MAX_N) do begin // and give begin a line to itself
    a[n] := a[0];
    for j := n downto 1 do inc( a[j - 1], a[j]);
    inc(n);
    Display();
  end;
end.
