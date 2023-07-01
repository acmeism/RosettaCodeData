program ZeckendorfRep_RC;

{$mode objfpc}{$H+}

uses SysUtils;

// Return Zeckendorf representation of the passed-in cardinal.
function ZeckRep( C : cardinal) : string;
var
  a, b, rem : cardinal;
  j, nrDigits: integer;
begin
  // Case C = 0 has to be treated specially
  if (C = 0) then begin
    result := '0';
    exit;
  end;
  // Find largest Fibonacci number not exceeding C
  a := 1;
  b := 1;
  nrDigits := 1;
  rem := C - 1;
  while (rem >= b) do begin
    dec( rem, b);
    inc( a, b);
    b := a - b;
    inc( nrDigits);
  end;
  // Fill in digits by reversing Fibonacci back to start
  SetLength( result, nrDigits);
  j := 1;
  result[j] := '1';
  for j := 2 to nrDigits do begin
    if (rem >= b) then begin
      dec( rem, b);
      result[j] := '1';
    end
    else result[j] := '0';
    b := a - b;
    dec( a, b);
  end;
//  Assert((a = 1) and (b = 1)); // optional check
end;

// Main routine
var
  C : cardinal;
begin
  for C := 1 to 20 do
    WriteLn( SysUtils.Format( '%2d: %s', [C, ZeckRep(C)]));
end.
