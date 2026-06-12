program RiordanA;
{
Console program to calculate Riordan numbers, using addition only.
Command line is e.g.  RiordanA 32  for first 32 Riordan numbers.
}
{$IFNDEF FPC}      // if not Free Pascal Compiler
{$APPTYPE CONSOLE} // this is needed for Delphi
{$ENDIF}
uses Math, SysUtils;
{$IFDEF FPC}
const N_MAX = 47;
{$ELSE}
const N_MAX = 46; // 47 should be OK for D2007 or later (not tested)
{$ENDIF}
type TUint64Array = array of Uint64;

// Store Riordan numbers in the passed-in array.
procedure StoreRiordan( var R : TUint64Array);
var
  h, j, k : integer;
begin
  h := High(R); // array is R[0..h], with h+1 elements
  R[0] := 1;
  for j := 1 to h do R[j] :=  0;
  for k := 2 to h do
    for j := Math.Min( 2*(k - 1), h) downto k do
      inc( R[j], R[j-1] + R[j-2]);
end;

// Main routine
var
  Riordan : TUint64Array;
  N, k : integer;
begin
  if (not SysUtils.TryStrToInt( ParamStr(1), {out} N))
  or (N < 2) or (N > N_MAX) then begin
    WriteLn( 'Enter  RiordanA N  (2 <N <= ', N_MAX,
             ' for first N Riordan numbers');
    exit;
  end;
  // Call zubroutine to store first N Riordan numbers
  SetLength( Riordan, N);
  StoreRiordan( Riordan);
  // Display Riordan numbers on console
  Write( 'First ', N, ' Riordan numbers');
  for k := 0 to N - 1 do begin
    if k mod 3 = 0 then WriteLn
    else Write('  ');
    Write( Riordan[k]:24);
  end;
  WriteLn;
end.
