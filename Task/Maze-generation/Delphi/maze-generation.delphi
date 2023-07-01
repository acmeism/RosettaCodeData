program MazeGen_Rosetta;

{$APPTYPE CONSOLE}

uses System.SysUtils, System.Types, System.Generics.Collections, System.IOUtils;

type
  TMCell = record
    Visited  : Boolean;
    PassTop  : Boolean;
    PassLeft : Boolean;
  end;
  TMaze  = array of array of TMCell;
  TRoute = TStack<TPoint>;

const
  mwidth  = 24;
  mheight = 14;

procedure ClearVisited(var AMaze: TMaze);
var
  x, y: Integer;
begin
  for y := 0 to mheight - 1 do
    for x := 0 to mwidth - 1 do
      AMaze[x, y].Visited := False;
end;

procedure PrepareMaze(var AMaze: TMaze);
var
  Route    : TRoute;
  Position : TPoint;
  d        : Integer;
  Pool     : array of TPoint; // Pool of directions to pick randomly from
begin
  SetLength(AMaze, mwidth, mheight);
  ClearVisited(AMaze);
  Position := Point(Random(mwidth), Random(mheight));
  Route := TStack<TPoint>.Create;
  try
    with Position do
    while True do
    begin
      repeat
        SetLength(Pool, 0);
        if (y > 0)         and not AMaze[x, y-1].Visited then Pool := Pool + [Point(0, -1)];
        if (x < mwidth-1)  and not AMaze[x+1, y].Visited then Pool := Pool + [Point(1,  0)];
        if (y < mheight-1) and not AMaze[x, y+1].Visited then Pool := Pool + [Point(0,  1)];
        if (x > 0)         and not AMaze[x-1, y].Visited then Pool := Pool + [Point(-1, 0)];

        if Length(Pool) = 0 then // no direction to draw from
        begin
          if Route.Count = 0 then Exit; // and we are back at start so this is the end
          Position := Route.Pop;
        end;
      until Length(Pool) > 0;

      d := Random(Length(Pool));
      Offset(Pool[d]);

      AMaze[x, y].Visited := True;
      if Pool[d].y = -1 then AMaze[x, y+1].PassTop  := True; // comes from down to up ( ^ )
      if Pool[d].x =  1 then AMaze[x, y].PassLeft   := True; // comes from left to right ( --> )
      if Pool[d].y =  1 then AMaze[x, y].PassTop    := True; // comes from left to right ( v )
      if Pool[d].x = -1 then AMaze[x+1, y].PassLeft := True; // comes from right to left ( <-- )
      Route.Push(Position);
    end;
  finally
    Route.Free;
  end;
end;

function MazeToString(const AMaze: TMaze; const S, E: TPoint): String; overload;
var
  x, y: Integer;
  v   : Char;
begin
  Result := '';
  for y := 0 to mheight - 1 do
  begin
    for x := 0 to mwidth - 1 do
      if AMaze[x, y].PassTop then Result := Result + '+'#32#32#32 else Result := Result + '+---';
    Result := Result + '+' + sLineBreak;
    for x := 0 to mwidth - 1 do
    begin
      if S = Point(x, y) then v := 'S' else
        if E = Point(x, y) then v := 'E' else
          v := #32'*'[Ord(AMaze[x, y].Visited) + 1];

      Result := Result + '|'#32[Ord(AMaze[x, y].PassLeft) + 1] + #32 + v + #32;
    end;
    Result := Result + '|' + sLineBreak;
  end;
  for x := 0 to mwidth - 1 do Result := Result + '+---';
  Result := Result + '+' + sLineBreak;
end;

procedure Main;
var
  Maze: TMaze;
begin
  Randomize;
  PrepareMaze(Maze);
  ClearVisited(Maze);     // show no route
  Write(MazeToString(Maze, Point(-1, -1), Point(-1, -1)));
  ReadLn;
end;

begin
  Main;

end.
