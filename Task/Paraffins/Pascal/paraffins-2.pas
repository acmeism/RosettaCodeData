program CountAlkanes;

{$mode objfpc}{$H+}

uses SysUtils; // only for output

type TArrayUint64 = array of uint64;
{
  Function to count alkanes, based on: Shinsaku Fujita,
  "Numbers of Alkanes and Monosubstituted Alkanes.
  A Long-Standing Interdisciplinary Problem over 130 Years",
  Bull. Chem. Soc. Jpn. Vol. 83, No. 1, 1–18 (2010)
}
function CountAlkanes() : TArrayUint64;
const
  MAX_RESULT_INDEX = 49; // as far as this code can get without multi-precision
  MAX_R_INDEX = MAX_RESULT_INDEX div 2;
var
  R : array [0..MAX_R_INDEX] of uint64;
  nrCentUnb : uint64; // number of centroidal unbalanced alkanes
  temp : uint64;
  m, n, h, i, j, k : integer;
begin
  SetLength( result, MAX_RESULT_INDEX + 1); // zero-based
{
  Calculate enough of the coefficients R[], where the generating function
     r(x) = R[0] + R[1]x + R[2]x^2 + R[3]x^3 + ...  satifies
     r(x) = 1 + (x/6)[r(x)^3 + 2r(x^3) + 3r(x)r(x^2)]  (Fujita, equation 4)
}
  R[0] := 1;
  n := 0;
  repeat
    if (n mod 3 = 0) then temp := 2*R[n div 3]
                     else temp := 0;
    for j := 0 to (n div 2) do begin
      inc( temp, 3 * R[j] * R[n - 2*j]);
    end;
    for j := 0 to n do begin
      for k := 0 to (n - j) do begin
        inc(temp, R[j] * R[k] * R[n - j - k]);
      end;
    end;
    Assert( temp mod 6 = 0);  // keep an eye on it
    inc(n);
    R[n] := temp div 6;
  until (n = MAX_R_INDEX);
{
  Now use the generating function
    (x/24)[r(x)^4 + 3r(x^2)^2 + *r(x)r(x^3) + 6r(x)^2r(x^2) + 6r(x^4)]
  where inserting r(x) up to the term in x^m will give the number of alkanes
  of orders 2m+1 and 2m+2, as the coefficients of x^(2m+1) and x^(2m+2).

  Note: In Fujita's paper, equation 23, the factor is 1/24 not x/24,
        but x/24 seems to be needed to give correct results.
}
  result[0] := 1;  // conventional
  for n := 1 to MAX_RESULT_INDEX do begin
    m := (n - 1) div 2; // so n = 2*m + 1 or 2*m + 2
    temp := 0;

    // These loops are written for clarity not efficiency
    for k := 0 to m do begin
      for j := 0 to m do begin
        for i := 0 to m do begin
          h := n - 1 - i - j - k;
          if  (h >= 0) and (h <= m) then inc( temp, R[h]*R[i]*R[j]*R[k]);
        end;
      end;
    end;

    if Odd(n) then begin
      for k := 0 to m do begin
        inc( temp, 3*R[k]*R[m - k]);
      end;
    end;

    for k := 0 to (n - 1) div 3 do begin
      j := n - 1 - 3*k;
      if (j <= m) then inc( temp, 8*R[j]*R[k]);
    end;

    for k := 0 to m do begin
      for j := 0 to m do begin
        i := n - 1 - 2*k - j;
        if (i >= 0) and (i <= m) then inc( temp, 6*R[i]*R[j]*R[k]);
      end;
    end;

    if (n mod 4 = 1) then inc( temp, 6*R[(n - 1) div 4]);

    Assert( temp mod 24 = 0);  // keep an eye on it
    nrCentUnb := temp div 24;
    if Odd(n) then
      result[n] := nrCentUnb
    else begin
      temp := R[n div 2];
      result[n] := nrCentUnb + (temp*(temp + 1) div 2);
    end;
  end;
end;

// Call function and display the results
var
  nrAlkanes : TArrayUint64;
  k : integer;
begin
  nrAlkanes := CountAlkanes();
  for k := 0 to Length( nrAlkanes) - 1 do
    WriteLn( SysUtils.Format( '%2d %d', [k, nrAlkanes[k]]));
end.
