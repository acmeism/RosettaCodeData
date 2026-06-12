program RiordanR;
{
Console program to calculate Riordan numbers, using the recurrence relation
  in the Rosetta Code task description.
Command line is e.g.  RiordanR 32  for first 32 Riordan numbers.
}
{$IFNDEF FPC}      // if not Free Pascal Compiler
{$APPTYPE CONSOLE} // this is needed for Delphi
{$ENDIF}
uses Math, SysUtils;
const N_MAX = 46;  // same for Free Pascal and Delphi
type TUint64Array = array of Uint64;

// Store Riordan numbers in the passed-in array.
procedure StoreRiordan( var R : TUint64Array);
var
  S, T : Uint64;
  h, k : integer;
begin
  h := High(R); // srrsy is R[0..h], with h+1 elements
  R[0] := 1;
  R[1] := 0;
 for k := 2 to h do begin
    S := 3*R[k - 2] + 2*R[k - 1];
{
  To get a few more values before UInt64 overflow, we avoid forming
  the product (k-1)*S. Given that (k-1)*S/(k+1) is an integer, we note:
  (1) if k is odd then (k-1)/2 and (k+1)/2 are coprime, so (k+1)/2 divides S;
  (2) if k is even then k-1 and k+1 are coprime, so k+1 divides S.
}
    if Odd(k) then
      T := S div ((k+1) div 2)
    else
      T := 2*(S div (k+1));
    R[k] := S - T;
  end;
end;

// Main routine.
var
  Riordan : TUint64Array;
  N, k : integer;
begin
  if (not SysUtils.TryStrToInt( ParamStr(1), {out} N))
  or (N < 2) or (N > N_MAX) then begin
    WriteLn( 'Enter  RiordanR N  (2 <N <= ', N_MAX,
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
