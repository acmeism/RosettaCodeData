program FaulhaberTriangle;
uses uIntX, uEnums, // units in the library IntXLib4Pascal
     SysUtils;

// Convert a rational num/den to a string, right-justified in the given width.
// Before converting, remove any common factor of num and den.
// For this application we can assume den > 0.
function RationalToString( num, den : TIntX;
                           minWidth : integer) : string;
var
  num1, den1, divisor : TIntX;
  w : integer;
begin
  divisor := TIntX.GCD( num, den);
  // TIntx.Divide requires the caller to specifiy the division mode
  num1 := TIntx.Divide( num, divisor, uEnums.dmClassic);
  den1 := TIntx.Divide( den, divisor, uEnums.dmClassic);
  result := num1.ToString;
  if not den1.IsOne then result := result + '/' + den1.ToString;
  w := minWidth - Length( result);
  if (w > 0) then result := StringOfChar(' ', w) + result;
end;

// Main routine
const
  r_MAX = 17;
var
  g : array [1..r_MAX + 1] of TIntX;
  r, s, k : integer;
  r_1_fac, sum, k_intx : TIntX;
begin
  // Calculate rows 0..17 of Faulhaner's triangle, and show rows 0..9.
  // For a given r, the subarray g[1..(r+1)] contains (r + 1)! times row r.
  r_1_fac := 1; // (r + 1)!
  g[1] := 1;
  for r := 0 to r_MAX do begin
    r_1_fac := r_1_fac * (r+1);
    sum := 0;
    for s := r downto 1 do begin
      g[s + 1] := r*(r+1)*g[s] div (s+1);
      sum := sum + g[s + 1];
    end;
    g[1] := r_1_fac - sum; // the scaled row must sum to (r + 1)!
    if (r <= 9) then begin
      for s := 1 to r + 1 do Write( RationalToString( g[s], r_1_fac, 7));
      WriteLn;
    end;
  end;

  // Use row 17 to sum 17th powers from 1 to 1000
  sum := 0;
  for s := r_MAX + 1 downto 1 do sum := (sum + g[s]) * 1000;
  sum := TIntx.Divide( sum, r_1_fac, uEnums.dmClassic);
  WriteLn;
  WriteLn( 'Sum by Faulhaber = ' + sum.ToString);

  // Check by direct calculation
  sum := 0;
  for k := 1 to 1000 do begin
    k_intx := k;
    sum := sum + TIntX.Pow( k_intx, r_MAX);
  end;
  WriteLn( 'by direct calc.  = ' + sum.ToString);
end.
