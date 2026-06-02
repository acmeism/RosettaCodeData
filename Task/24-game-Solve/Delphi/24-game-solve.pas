program TwentyFourGameSolver;

{
  Solver for the 24 game.

  Given (or randomly drawn) four digits in 1..9, exhaustively searches for
  every distinct expression that:
    - uses each digit exactly once
    - uses only +, -, *, / and parentheses
    - evaluates (in floating-point arithmetic) to 24

  Search space: 4! permutations x 5 parenthesizations (Catalan C_3)
               x 4^3 operator combinations = 7680 expressions.

  Usage:
    TwentyFourGameSolver                draw four random digits and solve
    TwentyFourGameSolver d1 d2 d3 d4    solve for the given four digits (1..9)
}

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes,
  System.Math;

type
  TOp = (opAdd, opSub, opMul, opDiv);
  TDigits = array [0 .. 3] of Integer;

const
  OpChars: array [TOp] of Char = ('+', '-', '*', '/');
  Target  = 24;
  Epsilon = 1E-9;

// ============================================================================
//  Evaluator
// ============================================================================

function Apply(A, B: Double; Op: TOp; out R: Double): Boolean;
begin
  Result := True;
  case Op of
    opAdd: R := A + B;
    opSub: R := A - B;
    opMul: R := A * B;
    opDiv:
      if Abs(B) < Epsilon then
        Result := False
      else
        R := A / B;
  end;
end;

{
  Five parenthesizations of A o1 B o2 C o3 D (Catalan C_3 = 5):
    0:  ((A o1 B) o2 C) o3 D
    1:  (A o1 (B o2 C)) o3 D
    2:  (A o1 B) o2 (C o3 D)
    3:  A o1 ((B o2 C) o3 D)
    4:  A o1 (B o2 (C o3 D))
}
function EvalShape(Shape: Integer; A, B, C, D: Double; O1, O2, O3: TOp;
  out R: Double): Boolean;
var
  T1, T2: Double;
begin
  Result := False;
  case Shape of
    0: Result := Apply(A,  B,  O1, T1) and Apply(T1, C,  O2, T2) and Apply(T2, D,  O3, R);
    1: Result := Apply(B,  C,  O2, T1) and Apply(A,  T1, O1, T2) and Apply(T2, D,  O3, R);
    2: Result := Apply(A,  B,  O1, T1) and Apply(C,  D,  O3, T2) and Apply(T1, T2, O2, R);
    3: Result := Apply(B,  C,  O2, T1) and Apply(T1, D,  O3, T2) and Apply(A,  T2, O1, R);
    4: Result := Apply(C,  D,  O3, T1) and Apply(B,  T1, O2, T2) and Apply(A,  T2, O1, R);
  end;
end;

function FormatShape(Shape: Integer; A, B, C, D: Integer; O1, O2, O3: TOp): string;
var
  C1, C2, C3: Char;
begin
  C1 := OpChars[O1];
  C2 := OpChars[O2];
  C3 := OpChars[O3];
  case Shape of
    0: Result := Format('((%d %s %d) %s %d) %s %d', [A, C1, B, C2, C, C3, D]);
    1: Result := Format('(%d %s (%d %s %d)) %s %d', [A, C1, B, C2, C, C3, D]);
    2: Result := Format('(%d %s %d) %s (%d %s %d)', [A, C1, B, C2, C, C3, D]);
    3: Result := Format('%d %s ((%d %s %d) %s %d)', [A, C1, B, C2, C, C3, D]);
    4: Result := Format('%d %s (%d %s (%d %s %d))', [A, C1, B, C2, C, C3, D]);
  else
    Result := '';
  end;
end;

// ============================================================================
//  Search
// ============================================================================

var
  Digits:    TDigits;
  Solutions: TStringList;

procedure TrySearch(const D: TDigits);
var
  Shape:      Integer;
  O1, O2, O3: TOp;
  R:          Double;
begin
  for Shape := 0 to 4 do
    for O1 := Low(TOp) to High(TOp) do
      for O2 := Low(TOp) to High(TOp) do
        for O3 := Low(TOp) to High(TOp) do
          if EvalShape(Shape, D[0], D[1], D[2], D[3], O1, O2, O3, R) then
            if SameValue(R, Target, Epsilon) then
              Solutions.Add(FormatShape(Shape, D[0], D[1], D[2], D[3], O1, O2, O3));
end;

procedure Permute(D: TDigits; K: Integer);
var
  I, Tmp: Integer;
begin
  if K >= 3 then
  begin
    TrySearch(D);
    Exit;
  end;
  for I := K to 3 do
  begin
    Tmp  := D[K]; D[K] := D[I]; D[I] := Tmp;
    Permute(D, K + 1);
    Tmp  := D[K]; D[K] := D[I]; D[I] := Tmp;
  end;
end;

// ============================================================================
//  Input / output
// ============================================================================

procedure GenerateRandomDigits;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Digits[I] := Random(9) + 1;
end;

procedure ParseDigitsFromArgs;
var
  I, V: Integer;
begin
  for I := 0 to 3 do
  begin
    V := StrToInt(ParamStr(I + 1));
    if (V < 1) or (V > 9) then
      raise EArgumentException.CreateFmt(
        'Digit %d is out of range (must be 1..9, got %d)', [I + 1, V]);
    Digits[I] := V;
  end;
end;

procedure ShowDigits;
var
  I: Integer;
  S: string;
begin
  S := '';
  for I := 0 to 3 do
  begin
    if I > 0 then
      S := S + '  ';
    S := S + IntToStr(Digits[I]);
  end;
  Writeln('Digits:  ', S);
end;

procedure PrintUsage;
begin
  Writeln('Usage:');
  Writeln('  TwentyFourGameSolver                draw four random digits and solve');
  Writeln('  TwentyFourGameSolver d1 d2 d3 d4    solve for the given digits (1..9)');
end;

var
  I: Integer;
begin
  Randomize;
  Solutions := TStringList.Create;
  Solutions.Sorted     := True;
  Solutions.Duplicates := dupIgnore;
  try
    try
      case ParamCount of
        0:
          GenerateRandomDigits;
        4:
          ParseDigitsFromArgs;
      else
        PrintUsage;
        ExitCode := 1;
        Exit;
      end;

      ShowDigits;
      Writeln;

      Permute(Digits, 0);

      if Solutions.Count = 0 then
      begin
        Writeln('No solution evaluating to 24 exists for these digits.');
        ExitCode := 2;
      end
      else
      begin
        Writeln(Format('%d distinct solution(s):', [Solutions.Count]));
        for I := 0 to Solutions.Count - 1 do
          Writeln('  ', Solutions[I], '  =  24');
      end;
    except
      on E: Exception do
      begin
        Writeln(ErrOutput, 'Error: ', E.ClassName, ': ', E.Message);
        ExitCode := 1;
      end;
    end;
  finally
    Solutions.Free;
  end;
end.
