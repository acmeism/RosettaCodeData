program CWIndex;

{-------------------------------------------------------------------------------
FreePascal command-line program.
Calculates index of a rational number in the Calkin-Wilf sequence,
  where the first term 1/1 has index 1.
Command line format is
  CWIndex <numerator> <denominator>
e.g. for the Rosetta Code example
  CWIndex 83116 51639
-------------------------------------------------------------------------------}

uses SysUtils;

var
  num, den : integer;
  a, b : integer;
  pwr2, index : qword; // 64-bit unsiged
begin
  // Read and validate input.
  num := SysUtils.StrToIntDef( paramStr(1), -1); // return -1 if not an integer
  den := SysUtils.StrToIntDef( paramStr(2), -1);
  if (num <= 0) or (den <= 0) then begin
    WriteLn( 'Numerator and denominator must be positive integers');
    exit;
  end;

  // Input OK, calculate and display index of num/den
  // The index may overflow 64 bits, so turn on overflow detection
{$Q+}
  a := num;
  b := den;
  pwr2 := 1;
  index := 0;
  try
    while (a <> b) do begin
      if (a < b) then
        dec( b, a)
      else begin
        dec( a, b);
        inc( index, pwr2);
      end;
      pwr2 := 2*pwr2;
    end;
    inc( index, pwr2);
    WriteLn( SysUtils.Format( 'Index of %d/%d is %u', [num, den, index]));
  except
    WriteLn( 'Index is too large for 64 bits');
  end;
end.
