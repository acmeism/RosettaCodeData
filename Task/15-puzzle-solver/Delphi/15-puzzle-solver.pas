program Puzzle15Solver;

{
  Solves the 15 puzzle using IDA* with an incrementally-maintained
  Manhattan-distance heuristic.

  Move notation follows the Rosetta Code task: u/d/l/r is the direction
  the BLANK moves (equivalently, the opposite direction of the sliding tile).

  Usage:
    Puzzle15Solver                     uses the Rosetta Code task board
    Puzzle15Solver fe169b4c0a73d852    16 hex digits, row-major, 0 = blank
    Puzzle15Solver 15 14 1 6 9 11 4 12 0 10 7 3 13 8 5 2
                                       16 space-separated tiles, 0 = blank
}

{$APPTYPE CONSOLE}
{$OPTIMIZATION ON}
{$RANGECHECKS OFF}
{$OVERFLOWCHECKS OFF}

uses
  System.SysUtils,
  System.StrUtils,
  System.Diagnostics,
  System.Math;

type
  TBoard = array [0 .. 15] of Byte;
  TMove = (mvNone, mvUp, mvDown, mvLeft, mvRight);
  TMovePath = array [0 .. 127] of TMove;

const
  MoveChar: array [TMove] of Char = (' ', 'u', 'd', 'l', 'r');
  Opposite: array [TMove] of TMove = (mvNone, mvDown, mvUp, mvRight, mvLeft);
  MoveDelta: array [TMove] of Integer = (0, -4, +4, -1, +1);

  GoalRow: array [0 .. 15] of Byte =
    (3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3);
  GoalCol: array [0 .. 15] of Byte =
    (3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2);

  DefaultBoard: TBoard =
    (15, 14, 1, 6,
      9, 11, 4, 12,
      0, 10, 7, 3,
     13,  8, 5, 2);

var
  Board: TBoard;
  BlankPos: Integer;
  Path: TMovePath;
  SolutionFound: Boolean;
  SolutionLen: Integer;
  NodesVisited: UInt64;

function CanMove(Blank: Integer; Mv: TMove): Boolean;
begin
  case Mv of
    mvUp:    Result := Blank >= 4;
    mvDown:  Result := Blank < 12;
    mvLeft:  Result := (Blank and 3) <> 0;
    mvRight: Result := (Blank and 3) <> 3;
  else
    Result := False;
  end;
end;

function ManhattanDistance: Integer;
var
  I, Tile: Integer;
begin
  Result := 0;
  for I := 0 to 15 do
  begin
    Tile := Board[I];
    if Tile = 0 then
      Continue;
    Result := Result + Abs((I shr 2) - GoalRow[Tile])
                     + Abs((I and 3) - GoalCol[Tile]);
  end;
end;

function DFS(G, H, Bound: Integer; LastMove: TMove): Integer;
var
  T, NextBound, NewBlank, OldBlank, Tile, DeltaH: Integer;
  OldRow, OldCol, NewRow, NewCol: Integer;
  Mv, Opp: TMove;
begin
  Inc(NodesVisited);
  if G + H > Bound then
    Exit(G + H);
  if H = 0 then
  begin
    SolutionFound := True;
    SolutionLen := G;
    Exit(G);
  end;

  NextBound := MaxInt;
  Opp := Opposite[LastMove];
  OldBlank := BlankPos;
  OldRow := OldBlank shr 2;
  OldCol := OldBlank and 3;

  for Mv := mvUp to mvRight do
  begin
    if (Mv = Opp) or not CanMove(OldBlank, Mv) then
      Continue;

    NewBlank := OldBlank + MoveDelta[Mv];
    NewRow := NewBlank shr 2;
    NewCol := NewBlank and 3;
    Tile := Board[NewBlank];

    // Tile slides from NewBlank into OldBlank; blank goes the other way.
    DeltaH := (Abs(OldRow - GoalRow[Tile]) + Abs(OldCol - GoalCol[Tile]))
            - (Abs(NewRow - GoalRow[Tile]) + Abs(NewCol - GoalCol[Tile]));

    Board[OldBlank] := Tile;
    Board[NewBlank] := 0;
    BlankPos := NewBlank;
    Path[G] := Mv;

    T := DFS(G + 1, H + DeltaH, Bound, Mv);
    if SolutionFound then
      Exit(T);
    if T < NextBound then
      NextBound := T;

    Board[NewBlank] := Tile;
    Board[OldBlank] := 0;
    BlankPos := OldBlank;
  end;

  Result := NextBound;
end;

procedure Solve;
var
  Bound, T, H0: Integer;
begin
  SolutionFound := False;
  NodesVisited := 0;
  H0 := ManhattanDistance;
  Bound := H0;
  while True do
  begin
    Writeln(Format('  iteration: bound=%d, nodes-so-far=%d', [Bound, NodesVisited]));
    T := DFS(0, H0, Bound, mvNone);
    if SolutionFound then
      Break;
    if T = MaxInt then
      Break;
    Bound := T;
  end;
end;

function IsSolvable: Boolean;
var
  I, J, Inv, BlankRow: Integer;
begin
  Inv := 0;
  for I := 0 to 14 do
    if Board[I] <> 0 then
      for J := I + 1 to 15 do
        if (Board[J] <> 0) and (Board[I] > Board[J]) then
          Inc(Inv);
  BlankRow := BlankPos shr 2;
  // 4x4 board, goal blank bottom-right: solvable iff (inversions + blank-row) is odd.
  Result := Odd(Inv + BlankRow);
end;

procedure ValidateBoard;
var
  Seen: array [0 .. 15] of Boolean;
  I: Integer;
begin
  FillChar(Seen, SizeOf(Seen), 0);
  for I := 0 to 15 do
  begin
    if Board[I] > 15 then
      raise EArgumentException.CreateFmt('Tile value out of range: %d', [Board[I]]);
    if Seen[Board[I]] then
      raise EArgumentException.CreateFmt('Duplicate tile value: %d', [Board[I]]);
    Seen[Board[I]] := True;
  end;
end;

procedure LocateBlank;
var
  I: Integer;
begin
  BlankPos := -1;
  for I := 0 to 15 do
    if Board[I] = 0 then
    begin
      BlankPos := I;
      Exit;
    end;
  raise EArgumentException.Create('Board has no blank (0) tile');
end;

procedure ParseHexBoard(const S: string);
var
  I: Integer;
begin
  if Length(S) <> 16 then
    raise EArgumentException.Create('Hex board string must be exactly 16 characters');
  for I := 0 to 15 do
    Board[I] := StrToInt('$' + S[I + 1]);
end;

procedure ParseDecBoard;
var
  I, V: Integer;
begin
  for I := 0 to 15 do
  begin
    V := StrToInt(ParamStr(I + 1));
    if (V < 0) or (V > 15) then
      raise EArgumentException.CreateFmt('Tile value out of range: %d', [V]);
    Board[I] := V;
  end;
end;

procedure PrintBoard;
var
  R, C, V: Integer;
begin
  for R := 0 to 3 do
  begin
    for C := 0 to 3 do
    begin
      V := Board[R * 4 + C];
      if V = 0 then
        Write('  . ')
      else
        Write(Format('%3d ', [V]));
    end;
    Writeln;
  end;
end;

procedure PrintSolution;
var
  I: Integer;
  Sb: TStringBuilder;
begin
  Sb := TStringBuilder.Create(SolutionLen);
  try
    for I := 0 to SolutionLen - 1 do
      Sb.Append(MoveChar[Path[I]]);
    Writeln('Solution: ', Sb.ToString);
  finally
    Sb.Free;
  end;
end;

procedure PrintUsage;
begin
  Writeln('Puzzle15Solver - IDA* solver for the 15 puzzle');
  Writeln;
  Writeln('Usage:');
  Writeln('  Puzzle15Solver');
  Writeln('      Solve the Rosetta Code task board.');
  Writeln('  Puzzle15Solver <16 hex digits>');
  Writeln('      Row-major board, 0 = blank. Example: fe169b4c0a73d852');
  Writeln('  Puzzle15Solver t0 t1 ... t15');
  Writeln('      16 space-separated tiles (0..15), 0 = blank.');
end;

var
  Sw: TStopwatch;
  Arg: string;
begin
  try
    case ParamCount of
      0:
        Board := DefaultBoard;
      1:
        begin
          Arg := ParamStr(1);
          if MatchText(Arg, ['/?', '-?', '-h', '--help', '/help']) then
          begin
            PrintUsage;
            Exit;
          end;
          ParseHexBoard(Arg);
        end;
      16:
        ParseDecBoard;
    else
      PrintUsage;
      ExitCode := 1;
      Exit;
    end;

    ValidateBoard;
    LocateBlank;

    Writeln('Initial board:');
    PrintBoard;
    Writeln;
    Writeln('Manhattan distance: ', ManhattanDistance);

    if not IsSolvable then
    begin
      Writeln('Puzzle is not solvable (parity check failed).');
      ExitCode := 2;
      Exit;
    end;

    Writeln('Running IDA*...');
    Sw := TStopwatch.StartNew;
    Solve;
    Sw.Stop;
    Writeln;

    if SolutionFound then
    begin
      Writeln(Format('Found optimal solution in %d moves.', [SolutionLen]));
      PrintSolution;
      Writeln(Format('Nodes visited: %d', [NodesVisited]));
      Writeln(Format('Time: %d ms', [Sw.ElapsedMilliseconds]));
    end
    else
    begin
      Writeln('No solution found.');
      ExitCode := 3;
    end;
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, 'Error: ', E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
