unit UConverter;
(*
Defines a converter object to output uniformly distributed random integers 1..7,
  given a source of uniformly distributed random integers 1..5.
*)
interface

type
  TFace5 = 1..5;
  TFace7 = 1..7;
  TDice5 = function() : TFace5;

type TConverter = class( TObject)
private
  fDigitBuf: array [0..19] of integer; // holds digits in base 7
  fBufCount, fBufPtr : integer;
  fDice5 : TDice5;  // passed-in generator for integers 1..5
  fNrDice5 : int64; // diagnostics, counts calls to fDice5
public
  constructor Create( aDice5 : TDice5);
  procedure Reset();
  function Dice7() : TFace7;
  property NrDice5 : int64 read fNrDice5;
end;

implementation

constructor TConverter.Create( aDice5 : TDice5);
begin
  inherited Create();
  fDice5 := aDice5;
  self.Reset();
end;

procedure TConverter.Reset();
begin
  fBufCount := 0;
  fBufPtr := 0;
  fNrDice5 := 0;
end;

function TConverter.Dice7() : TFace7;
var
  digit_holder, temp : int64;
  j : integer;
begin
  if fBufPtr = fBufCount then begin // if no more in buffer
    fBufCount := 0;
    fBufPtr := 0;
    repeat // first time through will usually be enough
      // Use supplied fDice5 to generate random 23-digit integer in base 5.
      digit_holder := 0;
      for j := 0 to 22 do begin
        digit_holder := 5*digit_holder + fDice5() - 1;
        inc( fNrDice5);
      end;
      // Convert to 20-digit number in base 7. (A simultaneous DivMod
      // procedure would be neater, but isn't available for int64.)
      for j := 0 to 19 do begin
        temp := digit_holder div 7;
        fDigitBuf[j] := digit_holder - 7*temp;
        digit_holder := temp;
      end;
      // Maximum possible is 5^23 - 1, which is 10214646460315315132 in base 7.
      // If leading digit in base 7 is 0 then low 19 digits are random.
      // Else number begins with 100, 101, or 102; and if with
      //   100 or 101 then low 17 digits are random. And so on.
      if fDigitBuf[19] = 0 then fBufCount := 19
      else if fDigitBuf[17] < 2 then fBufCount := 17
      else if fDigitBuf[16] = 0 then fBufCount := 16;
      // We could go on but that will do.
    until fBufCount > 0;
  end; // if no more in buffer
  result := fDigitBuf[fBufPtr] + 1;
  inc( fBufPtr);
end;
end.

program Dice_SevenFromFive;
(*
Demonstrates use of the UConverter unit.
*)
{$mode objfpc}{$H+}
uses
  SysUtils, UConverter;

function Dice5() : UConverter.TFace5;
begin
  result := Random(5) + 1; // Random(5) returns 0..4
end;

// Percentage points of the chi-squared distribution, 6 degrees of freedom.
// From New Cambridge Statistical Tables, 2nd edn, pp. 40-41.
const
  CHI_SQ_6df_95pc = 1.635;
  CHI_SQ_6df_05pc = 12.59;

// Main routine
var
  nrThrows, j, k : integer;
  nrFaces : array [1..7] of integer;
  X2, expected, diff : double;
  conv : UConverter.TConverter;
begin
  conv := UConverter.TConverter.Create( @Dice5);
  WriteLn( 'Enter 0 throws to quit');
  repeat
    WriteLn(''); Write( 'Number of throws (0 to quit): ');
    ReadLn( nrThrows);
    if nrThrows = 0 then begin
      conv.Free();
      exit;
    end;
    conv.Reset(); // clears count of calls to Dice5
    for k := 1 to 7 do nrFaces[k] := 0;
    for j := 1 to nrThrows do begin
      k := conv.Dice7();
      inc( nrFaces[k]);
    end;
    WriteLn('');
    WriteLn( SysUtils.Format( 'Number of throws = %10d', [nrThrows]));
    WriteLn( SysUtils.Format( 'Calls to Dice5   = %10d', [conv.NrDice5]));
    for k := 1 to 7 do
      WriteLn( SysUtils.Format( '   Number of %d''s = %10d', [k, nrFaces[k]]));

    // Calculation of chi-squared
    expected := nrThrows/7.0;
    X2 := 0.0;
    for k := 1 to 7 do begin
      diff := nrFaces[k] - expected;
      X2 := X2 + diff*diff/expected;
    end;
    WriteLn( SysUtils.Format( 'X^2 = %0.3f on 6 degrees of freedom', [X2]));
    if X2 < CHI_SQ_6df_95pc then      WriteLn( 'Too regular at 5% level')
    else if X2 > CHI_SQ_6df_05pc then WriteLn( 'Too irregular at 5% level')
    else                              WriteLn( 'Satisfactory at 5% level')
  until false;
end.
