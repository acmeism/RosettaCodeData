program CurzonNumbers;
uses SysUtils;
const
  MAX_CURZON_MEG = 100;
  RC_LINE_LENGTH = 66;

procedure ListCurzonNumbers( base : integer);
var
  k, n, m, x, testBit, maxCurzon : uint64;
  nrHits : integer;
  lineOut : string;
begin
  maxCurzon := 1000000*MAX_CURZON_MEG;
  k := uint64( base);
  nrHits := 0;
  n := 0;
  WriteLn;
  if Odd( base) then WriteLn( SysUtils.Format(
        'Curzon numbers with base %d up to %d million', [base, MAX_CURZON_MEG]))
  else WriteLn( SysUtils.Format(
        'First 50 Curzon numbers with base %d', [base]));
  lineOut := '';
  repeat
    inc(n); // possible (generalized) Curzon number
    m := k*n + 1; // modulus
    testBit := 1;
    repeat testBit := testBit shl 1 until testBit > n;
    testBit := testBit shr 2;
    // Calculate k^n modulo m
    x := k;
    while testBit > 0 do begin
      x := (x*x) mod m;
      if (testBit and n) <> 0 then x := (x*k) mod m;
      testBit := testBit shr 1;
    end;
    // n is a Curzon number to base k iff k^n + 1 is divisible by m
    if (x + 1) mod m = 0 then begin
      inc( nrHits);
      if Odd( base) then
        lineOut := lineOut + ' ' + SysUtils.IntToStr( n)
      else if (nrHits <= 50) then
        lineOut := lineOut + SysUtils.Format( '%5d', [n]);
      if Length( lineOut) >= RC_LINE_LENGTH then begin
        WriteLn( lineOut); lineOut := '';
      end
      else if (nrHits = 1000) then begin
        if lineOut <> '' then begin
          WriteLn( lineOut); lineOut := '';
        end;
        WriteLn( SysUtils.Format( '1000th = %d', [n]));
      end;
    end;
  until (n = maxCurzon) or (nrHits = 1000);
  if lineOut <> '' then WriteLn( lineOut);
end;

begin
  ListCurzonNumbers( 2);
  ListCurzonNumbers( 4);
  ListCurzonNumbers( 6);
  ListCurzonNumbers( 8);
  ListCurzonNumbers(10);
  ListCurzonNumbers( 3);
  ListCurzonNumbers( 5);
  ListCurzonNumbers( 7);
  ListCurzonNumbers( 9);
  ListCurzonNumbers(11);
end.
